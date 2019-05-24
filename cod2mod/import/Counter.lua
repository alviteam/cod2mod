Counter = {}
Counter.container = {}

Counter.set = function(name, delay, counter, step, stopCondition, onFinishFunction, ...)
	Counter.container.name = {
		['name'] = name,
		['delay'] = delay,
		['counter'] = counter,
		['step'] = step,
		['stopCondition'] = stopCondition,
		['onFinishFunction'] = onFinishFunction,
		['args'] = {...},
		['timer'] = function ()
			Counter.container.name.counter = Counter.container.name.counter + Counter.container.name.step
			if(not loadstring(Counter.container.name.stopCondition)) then
				setTimer(Counter.container.name.timer, Counter.container.name.delay, 1, Counter.container.name.name, Counter.container.name.delay, Counter.container.name.counter, Counter.container.name.step, Counter.container.name.stopCondition, Counter.container.name.onFinishFunction, Counter.container.name.args)
			else
				Counter.container.name.onFinishFunction(unpack(Counter.container.name.args))
			end
		end
	}
	
	
end

Counter.getCount = function(name)
	return Counter.container.name.counter
end