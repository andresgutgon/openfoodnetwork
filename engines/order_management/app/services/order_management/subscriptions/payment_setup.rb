# frozen_string_literal: true

module OrderManagement
  module Subscriptions
    class PaymentSetup
      def initialize(order)
        @order = order
      end

      def call!
        payment = create_payment
        return if @order.errors.any?

        payment.update_attributes(amount: @order.outstanding_balance)
        payment
      end

      private

      def create_payment
        payment = @order.pending_payments.last
        return payment if payment.present?

        @order.payments.create(
          payment_method_id: @order.subscription.payment_method_id
        )
      end
    end
  end
end
