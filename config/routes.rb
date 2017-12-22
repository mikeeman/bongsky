Rails.application.routes.draw do
  get 'pages/contact/send' => 'contact#send', to: '../../mailers/contactmailer_mailer.rb', as: :contact_email

  post 'pages/rsvp/send' => 'rsvp#send'

  root to: 'visitors#index'

end
