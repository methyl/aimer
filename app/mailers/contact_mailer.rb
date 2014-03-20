class ContactMailer < ActionMailer::Base
  default from: "kontakt@aimer.pl"

  def contact(contact)
    @contact = contact
    mail(to: 'kontakt@aimer.pl', subject: @contact.subject, reply_to: @contact.email)
  end
end
