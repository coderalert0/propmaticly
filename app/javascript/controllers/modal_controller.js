import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
    static targets = ["modal"];

    // Open the modal
    open(event) {
        event.preventDefault();
        const modalId = event.currentTarget.getAttribute("data-bs-target");
        const modal = document.querySelector(modalId);
        if (modal) {
            const modalInstance = new bootstrap.Modal(modal);
            modalInstance.show();
        }
    }

    // Close the modal
    close(event) {
        const modal = event.target.closest(".modal");
        if (modal) {
            const modalInstance = bootstrap.Modal.getInstance(modal);
            modalInstance.hide();
        }
    }
}
