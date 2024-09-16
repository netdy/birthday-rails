import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["calendar", "monthYear", "tooltip"]

  connect() {
    this.currentDate = new Date()
    this.renderCalendar()
    this.setupTooltip()
  }

  renderCalendar() {
    const year = this.currentDate.getFullYear()
    const month = this.currentDate.getMonth()
    
    this.monthYearTarget.textContent = new Intl.DateTimeFormat('th-TH', { year: 'numeric', month: 'long' }).format(this.currentDate)

    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)
    const daysInMonth = lastDay.getDate()
    const startingDay = firstDay.getDay()

    let html = '<table class="calendar"><tr><th>อา</th><th>จ</th><th>อ</th><th>พ</th><th>พฤ</th><th>ศ</th><th>ส</th></tr>'

    let day = 1
    let prevMonthDays = new Date(year, month, 0).getDate() - startingDay + 1

    for (let i = 0; i < 6; i++) {
      html += '<tr>'
      for (let j = 0; j < 7; j++) {
        if (i === 0 && j < startingDay) {
          html += `<td class="other-month"><span class="day-number">${prevMonthDays}</span></td>`
          prevMonthDays++
        } else if (day > daysInMonth) {
          html += `<td class="other-month"><span class="day-number">${day - daysInMonth}</span></td>`
          day++
        } else {
          const currentDate = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`
          html += `<td data-date="${currentDate}"><span class="day-number">${day}</span></td>`
          day++
        }
      }
      html += '</tr>'
      if (day > daysInMonth && i !== 5) break
    }
    html += '</table>'

    this.calendarTarget.innerHTML = html
    this.highlightBirthdays()
  }

  highlightBirthdays() {
    const birthdays = JSON.parse(this.element.dataset.birthdays)
    const birthdaysByDate = {}

    birthdays.forEach(person => {
      const birthDate = new Date(person.birthdate)
      if (birthDate.getMonth() === this.currentDate.getMonth()) {
        const dateKey = `${this.currentDate.getFullYear()}-${String(birthDate.getMonth() + 1).padStart(2, '0')}-${String(birthDate.getDate()).padStart(2, '0')}`
        if (!birthdaysByDate[dateKey]) {
          birthdaysByDate[dateKey] = []
        }
        birthdaysByDate[dateKey].push(person)
      }
    })

    Object.entries(birthdaysByDate).forEach(([dateKey, persons]) => {
      const cell = this.calendarTarget.querySelector(`[data-date="${dateKey}"]`)
      if (cell) {
        cell.classList.add('birthday')
        let birthdayInfo = persons.map(p => `🎂${p.nickname}`).join('<br>')
        if (persons.length > 2) {
          birthdayInfo = persons.slice(0, 2).map(p => `🎂${p.nickname}`).join('<br>') + '<br>...'
        }
        cell.innerHTML += `<div class="birthday-info">${birthdayInfo}</div>`
        
        const tooltipContent = persons.map(p => `${p.nickname} - ${p.note || 'ไม่มีหมายเหตุ'}`).join('<br>')
        cell.dataset.tooltip = tooltipContent
      }
    })
  }

  setupTooltip() {
    this.calendarTarget.addEventListener('mouseover', (event) => {
      const cell = event.target.closest('td')
      if (cell && cell.dataset.tooltip) {
        this.showTooltip(cell, cell.dataset.tooltip)
      }
    })

    this.calendarTarget.addEventListener('mouseout', () => {
      this.hideTooltip()
    })
  }

  showTooltip(element, content) {
    const tooltip = this.tooltipTarget
    tooltip.innerHTML = content // ใช้ innerHTML แทน textContent เพื่อรองรับ <br>
    tooltip.style.display = 'block'

    const rect = element.getBoundingClientRect()
    const tooltipRect = tooltip.getBoundingClientRect()

    let top = rect.top - tooltipRect.height - 10
    let left = rect.left + rect.width / 2 - tooltipRect.width / 2

    if (top < 0) top = rect.bottom + 10
    if (left < 0) left = 0
    if (left + tooltipRect.width > window.innerWidth) left = window.innerWidth - tooltipRect.width

    tooltip.style.top = `${top}px`
    tooltip.style.left = `${left}px`
  }

  hideTooltip() {
    this.tooltipTarget.style.display = 'none'
  }

  previousMonth() {
    this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() - 1)
    this.renderCalendar()
  }

  nextMonth() {
    this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1)
    this.renderCalendar()
  }
}