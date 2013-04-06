Onek::Application.routes.draw do
	root to: "static#index"
	match '/sync' => "sync#sync"
	# match '/sync' => "sync#sync_dummy"
	match '/cta' => 'static#cta', as: :cta
end