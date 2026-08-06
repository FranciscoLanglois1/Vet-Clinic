module AppointmentsHelper
  def status_badge_color(status)
    case status
    when "scheduled"
      "primary"
    when "in_progress"
      "warning"
    when "completed"
      "success"
    when "cancelled"
      "danger"
    else
      "secondary"
    end
  end
end
