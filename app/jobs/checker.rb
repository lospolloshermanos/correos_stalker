class Checker
  include SuckerPunch::Job

  def perform
    CorreosChecker.unfinished.each do |correos_checker|
    	correos_checker.check_tracking_state
    end
  end
end