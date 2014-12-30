class Chef
  class Provider
    class TcpTuning
      # Provider for the tcp_tuning Illumos systems
      #
      class Illumos < Chef::Provider::TcpTuning
        def action_update
          new_resource.settings.each do |k, v|
            ndd k, v
          end
        end

        private

        def ndd(key, value)
          execute "Set TCP #{key}" do
            command "ndd -set /dev/tcp tcp_#{key} #{value}"
            only_if "[ $(ndd /dev/tcp tcp_#{key}) -ne #{value} ]"
          end
        end
      end
    end
  end
end
