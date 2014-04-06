class ContactMailer < ActionMailer::Base
  default from: "kontakt@aimer.pl"

  def contact(contact)
    @contact = contact
    mail(from: 'kontakt@aimer.pl', reply_to: @contact.email, to: 'kontakt@aimer.pl', subject: 'Kontakt: ' + @contact.subject)
  end
end
