class ContactMailer < ActionMailer::Base
  default from: "kontakt@aimer.pl"

  def contact(contact)
    @contact = contact
    mail(from: @contact.email, to: 'kontakt@aimer.pl', subject: @contact.subject)
  end
end
