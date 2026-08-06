// app/javascript/application.js

// Importar Stimulus
import { Application } from "@hotwired/stimulus"
const application = Application.start()

// Importar tus controladores de Stimulus
import "./controllers"

// Importar otras librerías que necesites
import "trix"
import "@rails/actiontext"
import "trix/dist/trix.css"
// Desactivar cualquier intento de usar Turbo
//window.Turbo = false

// 5. Función para inicializar Trix
function initializeTrix() {
  console.log("🔧 Inicializando Trix...")
  
  if (typeof window.Trix === 'undefined') {
    console.warn("⚠️ Trix no está disponible")
    return
  }

  const editors = document.querySelectorAll('trix-editor')
  console.log(`📝 Encontrados ${editors.length} editores Trix`)
  
  editors.forEach((element, index) => {
    if (element.editor) {
      console.log(`✅ Editor ${index} ya inicializado`)
      return
    }
    
    try {
      element.editor = new window.Trix.Editor(element)
      console.log(`✅ Editor ${index} inicializado correctamente`)
    } catch (error) {
      console.error(`❌ Error inicializando editor ${index}:`, error)
    }
  })
}

// Ejecutar en diferentes momentos
document.addEventListener('DOMContentLoaded', initializeTrix)
document.addEventListener('turbo:load', initializeTrix)
document.addEventListener('turbo:render', initializeTrix)

console.log("✅ Aplicación cargada con Trix + Action Text")