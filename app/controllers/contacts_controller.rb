class ContactsController < ApplicationController

  def create
    contact = Contact.create!(contact_params)
    ContactMailer.contact(contact).deliver
    head :no_content
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :subject, :message)
  end

end
