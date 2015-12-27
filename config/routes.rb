Rails.application.routes.draw do
  get 'students/:id/payments/new' => 'payments#new', as: :new_student_payment
  get 'students/:id/payments' => 'students#payments', as: :student_payments
  get 'checks/new' => redirect('/checks')
  get 'stripes/new' => redirect('/stripes')
  get 'loans/new' => redirect('/loans')
  get 'wires/new' => redirect('/wires')
  get 'webhooks/stripe_webhook' => redirect('/')
  get 'performance_charts/new' => redirect('performance_charts')
  get 'payments' => 'payments#index', as: :payments
  post 'students/search' => 'students#search', as: 'search_students'
  post 'twilio/voice' => 'twilio#voice'
  post 'students/:student_id/:payment_type/:id/notify' => 'notifications#notify', as: :payment_notification
  post 'stripe/deposit' => 'webhooks#stripe_webhook'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :cohorts
  resources :performance_charts
  resources :stripes
  resources :wires
  resources :checks
  resources :loans
  resources :students

  root 'students#index'
end
