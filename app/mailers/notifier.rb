class Notifier < ActionMailer::Base
  # default :from => "admin@appstore.com"
  
  def contact(toemail, fromemail, message)
    
    mail( :to => toemail,
          :from => fromemail,
          :subject => "Tropo AppStore Update",
          :body => message)
             
  end
  
end
