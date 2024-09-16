import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "loginBtn", "registrationBtn", "loginForm", "registrationForm" ]

  toggleLogin() {
    this.loginBtnTarget.classList.add("active")
    this.registrationBtnTarget.classList.remove("active")
    this.loginFormTarget.style.display = "block"
    this.registrationFormTarget.style.display = "none"
  }

  toggleRegistration() {
    this.loginBtnTarget.classList.remove("active")
    this.registrationBtnTarget.classList.add("active")
    this.loginFormTarget.style.display = "none"
    this.registrationFormTarget.style.display = "block"
  }
}