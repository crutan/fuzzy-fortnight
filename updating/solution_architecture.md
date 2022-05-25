# Problem:

We deal with loads of products. Over 500k at the moment, with the goal of supporting 1.5 million. We need to update our products on our shopify store as fast as possible. The types of things we update are inventory numbers, prices, descriptions, images, etc. Regularly we get price changes for half the catalog at a time (think black friday cyber monday deals). 

The challenge here is to update the products on the store as fast as possible given the constraints:
	1. Rate Limit at the endpoint to update uses leaky bucket. 
		1. 80 requests / api_key, 
		2. leak rate: 4 requests/second 
		3. you have 3 api_keys
	2. The query to gather data to build the update request currently takes 5 seconds.
	3. Some updates are more time sensitive than others. Example, 200k image updates come through and need to be updated, but when 50 inventory updates come through they need to be executed first.

You don’t need to write actual code here, but maybe pseudo code or write up how you would build the most efficient updating system possible.

## Approach

Okay - so we have 3 keys, I'm assuming the bucket can hold 80 requests, and it leaks 4 per second.  So realistically, we're limited to 12 requests a second being processed, and we can burst to 240 requests in a single second if we have to - though that would then take 20 seconds to clear...realistically, though, we want to push as many requests in as we can, and lean on the API to tell us when it can handle more.  

I'd build a set of queues on our end of things for updates - a High, Medium and Low priority queue.  FIFO queues in all cases.  Jobs are able to insert at the end of any queue.  Each entry in the queue is an object with an endpoint URL and a payload.

This lets the process that builds the updates be as long as need be - it can insert jobs into the queue as it builds them, and another process 

Workers can be fired up to run against these queues.  A worker could look something like this:

	# API Keys are stored in an array like: 
	@keys =	[
			{ key: API_KEY, wait_time: 0 }
		]

	# Main Loop
	while true
		queue = nil
		if high_priority_queue.has_jobs?
			queue = high_priority_queue
		elsif medium_priority_queue.has_jobs?
			queue = medium_priority_queue
		elsif low_priority_queue.has_jobs?
			queue = low_priority_queue
		else
			break
		end
		job = queue.shift
		success, retry = submit(job)
		queue.push(job) if !success && retry
	end

	# Submit:
	#	pull the first api key in the list where wait_time < Time.now.to_i, and attempt to submit the request 
	#	- if we get a 429 (too many requests, then set that key's wait time a second into the future, and try submitting again
	#	- if we get a 200, everything's good
	#	- if we get 
	# Regardless, return two bits - success / failure, and retry.  0, 1 == failure, retry - 0, 0 == failure, no-retry
	def submit_job(job)
		key_index = @keys.find_index {|k| k[:wait_time] < Time.now.to_i}
		result = submit_api_call(job, @keys[key_index][:key]) # Hopefully this is clearly an abstraction - this would be a call to net::http or httparty or whatever

		if result.code == 429
			keys[key_index][:wait_time] = Time.now.to_i + 1	
			return submit_job(job)

		elsif result.code == 500
			log that the job failed - do not retry
			return false, false

		elsif results.code >= 200 && result.code < 300
			log that the job succeeded for this item somewhere
			return true, false
		else
			log that something weird happened - perhaps put this job on the bottom of a queue
			return false, true
		end
	end

