module Spree
  class ShipmentMailer < BaseMailer
    def shipped_email(shipment, resend = false)
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      subject = "Aimer.pl - transport wysłany!"
      mail(to: @shipment.order.email, from: from_address, subject: subject)
    end
  end
end
