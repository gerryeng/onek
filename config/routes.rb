Onek::Application.routes.draw do
  root to: "static#index"
  match '/sync' => "sync#sync"
  match '/cta' => 'static#cta', as: :cta
  
  
end