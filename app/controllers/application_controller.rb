# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :change_flash_keys
  skip_before_action :verify_authenticity_token

  def current_organization
    current_user.organization
  end

  def current_ability
    @current_ability ||= begin
      current_ability = Abilities::Ability.new(current_user)

      if controller_name == 'home'
        current_ability.merge(Abilities::PortfolioAbility.new(current_user))
        current_ability.merge(Abilities::BuildingAbility.new(current_user))
        current_ability.merge(Abilities::ComplaintAbility.new(current_user))
        current_ability.merge(Abilities::ViolationAbility.new(current_user))
        current_ability.merge(Abilities::InspectionAbility.new(current_user))
      end

      controller_names.to_a.each do |controller_name|
        model_name = controller_name.classify
        model_ability = begin
          "Abilities::#{model_name}Ability".constantize
        rescue StandardError
          nil
        end
        if model_ability.present? && model_abilities[model_ability].nil?
          model_abilities[model_ability] = model_ability.new(current_user)
          current_ability.merge(model_abilities[model_ability])
        end
      end
      current_ability
    end
  end

  def can?(*args)
    merge_ability(args[1])
    current_ability.can?(*args)
  end

  def cannot?(*args)
    merge_ability(args[1])
    current_ability.cannot?(*args)
  end

  def authorize!(*args)
    merge_ability(args[1])
    current_ability.authorize!(*args)
  end

  def model_abilities
    @model_abilities ||= {}
  end

  def controller_names
    @controller_names ||= begin
      regex_digit = /\d/
      regex_uuid = /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/
      controller_names = request.path.split('/')
      controller_names = controller_names.reject do |p|
        p.match?(regex_uuid) || p.match?(regex_digit) || p.empty?
      end
      controller_names = controller_names.map { |p| File.basename(p, File.extname(p)) }
      controller_names.take(controller_names.index(controller_name) + 1) if controller_names.include?(controller_name)
    end
  end

  def merge_abilities(*model_names)
    model_names.each do |model_name|
      merge_ability(model_name.to_s)
    end
  end

  def merge_ability(model)
    model_name = model.is_a?(Class) ? model.name : model.class.name
    model_ability = begin
      "Abilities::#{model_name}Ability".constantize
    rescue StandardError
      nil
    end
    return unless model_ability.present? && model_abilities[model_ability].nil?

    model_abilities[model_ability] = model_ability
    current_ability.merge(model_ability.new(current_user))
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error("Unauthorized access: #{exception} by user id: #{current_user.id}")
    flash[:danger] = t(:unauthorized_access_error)
    redirect_to root_path
  end

  private

  def change_flash_keys
    %i[notice alert].each do |key|
      if flash[key]
        flash[:primary] = flash[key]
        flash.delete(key)
      end
    end
  end
end
