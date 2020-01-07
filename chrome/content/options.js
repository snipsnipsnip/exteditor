// Idea taken from https://gist.github.com/eligrey/738199/acde24c71180c8a6fe7606dc9673888fb7e6dddc
document.addEventListener('DOMContentLoaded', () => {
    for (let e of document.querySelectorAll("[data-text]")) {
        for (let [attr, key] of Object.entries(e.dataset)) {
            let msg = (attr === 'text' || attr.startsWith("attr")) && key && browser.i18n.getMessage(key)
            if (!msg) {
                console.log('skipped', { attr, key })
            } else if (attr === 'text') {
                e.appendChild(document.createTextNode(msg))
            } else {
                e.setAttribute(attr.substr(4), msg)
            }
        }
    }
})