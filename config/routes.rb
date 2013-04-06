Onek::Application.routes.draw do
  root to: "static#index"


  match '/sync' => "api#sync"
end
