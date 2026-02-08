require "stackprof"

StackProf.run(mode: :wall, out: "stackprof.dump", interval: 1000, raw: true) do
  require_relative "impulse_response/main"
end
