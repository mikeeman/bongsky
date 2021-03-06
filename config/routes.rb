Rails.application.routes.draw do

  get 'pages/contact/send' => 'contact#send', to: '../../mailers/contactmailer_mailer.rb', as: :contact_email

  post 'pages/rsvp/send' => 'rsvp#send'

  post 'pages/uber/send' => 'uber#send'

  post 'pages/uploads/send' => 'uploads#send'

  get 'pages/uploads' => 'pages#show'

  root to: 'visitors#index'

end
