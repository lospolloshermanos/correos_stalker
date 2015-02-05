class Checker
  include SuckerPunch::Job

  def perform
    CorreosChecker.unfinished.each do |correos_checker|
    	correos_checker.check_tracking_state
    end

    CorreosChecker.unconfirmed.each do |correos_checker|
        correos_checker.remove_tracking_number
    end

    CorreosChecker.completed.each do |correos_checker|
    	correos_checker.remove_tracking_number
    end
  end
end