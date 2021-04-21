require 'rails_helper'

RSpec.describe Tenants::Throttle do
  let!(:tenant) { create(:tenant) }

  subject do
    described_class.new(tenant.api_key)
  end

  before do
    allow(Tenant).to receive(:find_by).and_return(tenant)
  end

  describe '.track' do
    before do
      allow(tenant).to receive(:track_request)
      allow(subject).to receive(:track_daily_request)
      allow(subject).to receive(:initialize_daily_tracking)

      subject.track
    end

    it 'calls tenant track_request method' do
      expect(tenant).to have_received(:track_request)
    end

    it 'calls track_daily_request method' do
      expect(subject).to have_received(:track_daily_request)
    end

    context 'when daily tracking is initialized' do
      before do
        allow(subject).to receive(:daily_tracking_initialized?).and_return(true)

        subject.track
      end

      it 'does not call initialize_daily_tracking method' do
        expect(subject).to_not have_received(:initialize_daily_tracking)
      end
    end

    context 'when daily tracking is not initialized' do
      before do
        allow(subject)
          .to receive(:daily_tracking_initialized?)
          .and_return(false)

        subject.track
      end

      it 'calls initialize_daily_tracking method' do
        expect(subject).to have_received(:initialize_daily_tracking)
      end
    end
  end

  describe '.block' do
    context 'Quota limit reached' do
      before do
        allow(subject)
          .to receive(:daily_count)
          .and_return(Tenants::Throttle::QUOTA_LIMIT)
      end

      context 'User must wait 10 seconds until next request' do
        before do
          allow(subject).to receive(:must_wait?).and_return(true)
        end

        context 'Daily tracking initialized' do
          before do
            allow(subject)
              .to receive(:daily_tracking_initialized?)
              .and_return(true)
          end

          it 'returns true' do
            expect(subject.blocked?).to be_truthy
          end
        end

        context 'Daily tracking not initialized' do
          before do
            allow(subject)
              .to receive(:daily_tracking_initialized?)
              .and_return(false)
          end

          it 'returns false' do
            expect(subject.blocked?).to be_falsy
          end
        end
      end

      context 'User does not need to wait 10 seconds' do
        before do
          allow(subject).to receive(:must_wait?).and_return(false)
        end

        context 'Daily tracking initialized' do
          before do
            allow(subject)
              .to receive(:daily_tracking_initialized?)
              .and_return(true)
          end

          it 'returns false' do
            expect(subject.blocked?).to be_falsy
          end
        end

        context 'Daily tracking not initialized' do
          before do
            allow(subject)
              .to receive(:daily_tracking_initialized?)
              .and_return(false)
          end

          it 'returns false' do
            expect(subject.blocked?).to be_falsy
          end
        end
      end
    end

    context 'Quota limit not reached' do
      before do
        allow(subject)
          .to receive(:daily_count)
          .and_return(Tenants::Throttle::QUOTA_LIMIT - 1)
      end

      it 'returns false' do
        expect(subject.blocked?).to be_falsy
      end
    end
  end
end
