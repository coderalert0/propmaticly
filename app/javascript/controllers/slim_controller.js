import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

// Connects to data-controller="slim"
export default class extends Controller {
  connect() {
    new SlimSelect({
      select: this.element,

      settings: {
        showSearch: false,
        placeholderText: ''
      }
    })

    document.querySelectorAll('.ss-arrow').forEach((arrow) => {
      arrow.style.display = 'none';
    });
  }
}
