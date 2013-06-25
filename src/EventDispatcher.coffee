define [], () ->

	class EventDispatcher

		constructor: () ->
			@events = []

		addEventListener: ( event, callback ) ->
			# instantiate this with an array if it's the first time we're calling this event
			if @events[event] == undefined
				@events[event] = []

			if @events[event]
				@events[event].push( callback )
			return false

		removeEventListener: ( event, callback ) ->
			if @events[event]
				for i in [0..@events[event].length-1]
					if @events[event][i] == callback
						@events[event].splice( i, 1 )
						return true
			else
				return false

		dispatch: ( event, data ) ->
			if data == undefined
				data = -1
			if @events.hasOwnProperty(event)
				for i in [0..@events[event].length-1]
					@events[event][i] data

	return EventDispatcher