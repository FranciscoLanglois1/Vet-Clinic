# db/seeds.rb
puts "=" * 60
puts "🌱 INICIANDO SEED..."
puts "=" * 60

# Limpiar base de datos
puts "🗑️  Limpiando base de datos..."
Treatment.destroy_all
Appointment.destroy_all
Pet.destroy_all
Owner.destroy_all
Vet.destroy_all
User.destroy_all

# Limpiar Active Storage (opcional, solo si quieres eliminar archivos viejos)
# ActiveStorage::Attachment.destroy_all
# ActiveStorage::Blob.destroy_all

puts "=" * 60
puts "👤 Creando usuarios..."

def create_user(email, password, first_name, last_name, role)
  user = User.new(
    email: email,
    password: password,
    password_confirmation: password,
    first_name: first_name,
    last_name: last_name,
    role: role
  )
  
  if user.respond_to?(:confirmed_at)
    user.confirmed_at = Time.now
  end
  
  user.save!
  puts "  ✅ #{role}: #{email} / #{password}"
  user
end

admin_user = create_user("admin@vetclinic.com", "admin123", "Admin", "Sistema", :admin)
vet_user1 = create_user("ana.vet@vetclinic.com", "vet123", "Ana", "Martínez", :vet)
vet_user2 = create_user("carlos.vet@vetclinic.com", "vet456", "Carlos", "Rodríguez", :vet)
owner_user1 = create_user("juan.owner@vetclinic.com", "owner123", "Juan", "Pérez", :owner)
owner_user2 = create_user("maria.owner@vetclinic.com", "owner456", "María", "Gómez", :owner)

puts "=" * 60
puts "👤 Creando owners..."

owner1 = Owner.create!(
  user_id: owner_user1.id,
  first_name: "Juan",
  last_name: "Pérez",
  email: "juan.perez@email.com",
  phone: "+56912345678",
  address: "Calle Principal 123, Santiago"
)
puts "  ✅ Owner 1: #{owner1.first_name} #{owner1.last_name}"

owner2 = Owner.create!(
  user_id: owner_user2.id,
  first_name: "María",
  last_name: "Gómez",
  email: "maria.gomez@email.com",
  phone: "+56987654321",
  address: "Avenida Los Pajaritos 456, Santiago"
)
puts "  ✅ Owner 2: #{owner2.first_name} #{owner2.last_name}"

puts "=" * 60
puts "🐶 Creando pets..."

# Helper para adjuntar foto si existe
def attach_photo(pet, filename)
  photo_path = Rails.root.join('app/assets/images', filename)
  if File.exist?(photo_path)
    pet.photo.attach(
      io: File.open(photo_path),
      filename: filename,
      content_type: "image/#{File.extname(filename).delete('.')}"
    )
    puts "    📸 Foto adjuntada: #{filename}"
  else
    puts "    ⚠️  Foto no encontrada: #{filename}"
  end
rescue => e
  puts "    ❌ Error al adjuntar foto: #{e.message}"
end

# Crear pets SIN el campo photo
pet1 = owner1.pets.create!(
  name: "Firulais",
  species: "dog",
  breed: "Labrador",
  date_of_birth: "2020-01-01",
  weight: 25,
  photo: "Pet1.jpg"
)

pet2 = owner1.pets.create!(
  name: "Michi",
  species: "cat",
  breed: "Siames",
  date_of_birth: "2021-03-15",
  weight: 5,
  photo: "Pet2.jpg"
)

pet3 = owner2.pets.create!(
  name: "Luna",
  species: "cat",
  breed: "Persa",
  date_of_birth: "2020-06-20",
  weight: 4,
  photo: "Pet3.jpg"
)

pet4 = owner2.pets.create!(
  name: "Rocky",
  species: "dog",
  breed: "Bulldog",
  date_of_birth: "2019-11-10",
  weight: 20,
  photo: "Pet4.jpg"
)

puts "=" * 60
puts "👨‍⚕️ Creando veterinarios..."

vet1 = Vet.create!(
  user_id: vet_user1.id,
  first_name: "Ana",
  last_name: "Martínez",
  email: "ana.martinez@vetclinic.com",
  phone: "+56922223333",
  specialization: "Medicina General"
)
puts "  ✅ Vet 1: #{vet1.first_name} #{vet1.last_name}"

vet2 = Vet.create!(
  user_id: vet_user2.id,
  first_name: "Carlos",
  last_name: "Rodríguez",
  email: "carlos.rodriguez@vetclinic.com",
  phone: "+56944445555",
  specialization: "Cirugía"
)
puts "  ✅ Vet 2: #{vet2.first_name} #{vet2.last_name}"

puts "=" * 60
puts "📅 Creando citas..."

appointment1 = Appointment.create!(
  pet: pet1,
  vet: vet1,
  date: Time.now + 1.day,
  reason: "Chequeo anual",
  status: "scheduled"
)
puts "  ✅ Cita 1"

appointment2 = Appointment.create!(
  pet: pet2,
  vet: vet1,
  date: Time.now + 2.days,
  reason: "Vacunación",
  status: "scheduled"
)
puts "  ✅ Cita 2"

appointment5 = Appointment.create!(
  pet: pet2,
  vet: vet2,
  date: Time.now + 3.days,
  reason: "Segunda opinión",
  status: "scheduled"
)
puts "  ✅ Cita 3"

appointment3 = Appointment.create!(
  pet: pet3,
  vet: vet1,
  date: Time.now - 2.days,
  reason: "Revisión",
  status: "completed"
)
puts "  ✅ Cita 4"

appointment4 = Appointment.create!(
  pet: pet4,
  vet: vet2,
  date: Time.now - 5.days,
  reason: "Cirugía",
  status: "completed"
)
puts "  ✅ Cita 5"

appointment6 = Appointment.create!(
  pet: pet3,
  vet: vet2,
  date: Time.now + 4.days,
  reason: "Seguimiento",
  status: "scheduled"
)
puts "  ✅ Cita 6"

puts "=" * 60
puts "💊 Creando tratamientos..."

treatment1 = Treatment.create!(
  appointment: appointment3,
  name: "Vacuna Antirrábica",
  medication: "Rabies Vaccine",
  dosage: "1 ml",
  administered_at: Time.now - 1.day,
  notes: "<h3>Vaccination Procedure</h3>
          <p>Administered <strong>rabies vaccine</strong> following standard protocol.</p>
          <h4>Steps performed:</h4>
          <ul>
            <li>Physical examination before vaccination</li>
            <li>Temperature check: <strong>38.5°C (101.3°F)</strong> - normal</li>
            <li>Subcutaneous injection in cervical region</li>
            <li>15-minute observation period post-vaccination</li>
          </ul>
          <p><strong>Status:</strong> <em>OK</em> - No adverse reactions observed.</p>
          <p><em>Next dose scheduled in 1 year.</em></p>"
)
puts "  ✅ Tratamiento 1"

treatment2 = Treatment.create!(
  appointment: appointment4,
  name: "Procedimiento Quirúrgico",
  medication: "Anestesia General",
  dosage: "Según peso",
  administered_at: Time.now - 4.days,
  notes: "<h3>Surgical Procedure Report</h3>
          <p><strong>Procedure:</strong> Routine ovariohysterectomy (spay)</p>
          <h4>Pre-operative:</h4>
          <ul>
            <li><strong>12-hour fast</strong> completed before procedure</li>
            <li>Pre-anesthetic blood work: <em>within normal limits</em></li>
            <li>Pre-medication: Acepromazine <strong>0.05 mg/kg</strong></li>
          </ul>
          <h4>Intra-operative:</h4>
          <ul>
            <li>Anesthesia induced with Propofol (<strong>4 mg/kg</strong>)</li>
            <li>Maintained with Isoflurane at <strong>1.5%</strong></li>
            <li>Vital signs monitored throughout procedure</li>
            <li>Surgery duration: <strong>45 minutes</strong></li>
            <li>No complications during procedure</li>
          </ul>
          <h4>Post-operative:</h4>
          <ul>
            <li>Analgesic: <strong>Meloxicam</strong> for pain management</li>
            <li>Prophylactic antibiotics administered</li>
            <li>Recovery period: <strong>uneventful</strong></li>
          </ul>
          <p><strong>Status:</strong> <em>Done</em> - Patient recovering well in post-op area.</p>
          <p><em>Follow-up appointment scheduled for suture removal in 10-14 days.</em></p>"
)
puts "  ✅ Tratamiento 2"

puts "=" * 60
puts "📋 RESUMEN FINAL:"
puts "  - Usuarios: #{User.count}"
puts "  - Owners: #{Owner.count}"
puts "  - Pets: #{Pet.count}"
puts "  - Vets: #{Vet.count}"
puts "  - Appointments: #{Appointment.count}"
puts "  - Treatments: #{Treatment.count}"
puts "=" * 60
puts "✅ SEED COMPLETADO EXITOSAMENTE!"
puts ""
puts "🔑 CREDENCIALES DE PRUEBA:"
puts "  Admin: admin@vetclinic.com / admin123"
puts "  Owner: juan.owner@vetclinic.com / owner123"
puts "  Owner: maria.owner@vetclinic.com / owner456"
puts "  Vet:   ana.vet@vetclinic.com / vet123"
puts "  Vet:   carlos.vet@vetclinic.com / vet456"
puts "=" * 60