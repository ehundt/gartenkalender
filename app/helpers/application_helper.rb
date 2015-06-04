module ApplicationHelper
  def markdown # TODO: this will be called several times, but should be created only once!
    require 'logger'
    Logger.new("log/debug.log").debug("new Redcarpet markdown object created!")
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def help_content
    content = '<table class="table"><tr><td>'
    content += image_tag("world-globe32x32.png")
    content += '</td><td>Zum Veröffentlichen dieser Pflanzentips auf dieses Icon klicken.'
    content += '</td></tr><tr><td>'
    content += image_tag "plant_active.gif", height: "42px", width: "30px"
    content += '</td><td>Pflanze aktiv bzw. inaktiv schalten durch Klick auf die Pflanze. Nur die Pflegetips für aktive Pflanzen werden in der Aufgabenliste angezeigt.'
    content += '</td></tr><tr><td>'
    content += image_tag "thumb_up_not_voted.png"
    content += '</td><td>War diese Pflanzenbeschreibung besonders hilfreich? Dann klicke auf dieses Icon. Änderst Du Deine Meinung wieder, klicke ein zweites Mal.'
    content += '</td></tr></table>'
    content.html_safe
  end
end
