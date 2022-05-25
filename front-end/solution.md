# Problem

When a customer selects their vehicle on our store to search for parts that fit their vehicle, how would we display extra information about their vehicle? The constraint here is that the front end is HTML and Javascript, but you have access to AWS and all of it’s wonders. Here is an example of what we could display on the front end immediately after they select their vehicle. 
	
Questions to answer:
1. Where/how would you store the data?

The ideal solution here is probably some sort of in-memory resident cache.  The hunk of html is reasonably small, and probably reasonably easy to generate - something like a rails fragment cache would do the job there.  Likewise, while there are probably a lot of car models and trims, there also most likely aren't really _that_ many.  To really optimize, there would need to be some kind of trigger (a change to recommended fitment for a vehicle) - but if that were possible, then I'd recommend writing the structured data out to a memory-resident cache and letting the browser pick up from there (store JSON for the fitment, along with a CDN url for the image and let JS in the browser handle building HTML)


2. The vehicle is stored via cookies once the customer selects Year, Make, Model, Submodel. Using Javascript write up something to show how you would get the data that you stored.

I'd put it in browser storage - localStorage(); in the browser.  Which is where you all put it.  Localstorage has keys 'make', 'model', 'submodel' and 'year' that store this information on the website now once a user searches for their car.

As mentioned, its currently stored in localStorage - so localStorage.get('make'), for example, will return the stored make.  But - if we wanted to store it in a cookie, then we'd need to write functions to get that data out of the cookie, or lean on a JS framework that makes it easy.

A function like this will do the trick:

function getCookieValue(name) {
    var x = document.cookie.split(/; /).find(function(cookie) {
        const [n,v] = cookie.split(/=/);
	return n == name;
    });
    if (x) {
        return x.split(/=/)[1];
    } else {
        return null;
    }
}

Then we can go get the cookie values (getCookieValue('make') - for example, to get the make)

3. The image comes from a separate API from where you’re storing the other vehicle data, how would you accomplish this safely assuming it has it’s own rate limits and is unreliable.
4. What could you do to make this small feature fast and responsive to the customer changing their vehicle?
5. Imagine we receive 500 requests per second, this solution needs to be scalable. How can you guarantee it won’t bug out or look awful/broken if some of the service was faulty.

All of these questions more or less resolve down to issues around scale.  I would recommend against relying on any unreliable / rate-limited API in production, especially if the data isn't likely to change frequently - like the image of a car...that's something that _probably_ doesn't change very often.  So I'd recommend writing a job to go through that API and pull out every car image it has, and then write them out to S3/Cloudfront and then figure out how often to refresh it.  Adding images means we'd be changing other data - adding makes/years/models/submodels of car, so we'd have triggering events available to refresh the image data.

It should work to concatenate the year_make_model_submodel to use as a ID or key - one would hope that is unique enough, as it is what the user is selecting.  

6. Given this idea of dynamically producing data based on the customers actions, what other types of front end features could we present to the customer? 

Right now the site gives me parts based on what I select, which is cool, but I wonder if starting at a higher level - like recommending projects that I can do for my car would be a good idea - that obviously requires more content authoring, but I can see some of that over on the youtube side of things - but pull it in to build shopping lists of parts that people might need in order to do specific mods.

Beyond that, though, maybe showing me what other owners of my car (or class of car) have done/purchased?  Right now the site has that little toast that shows me that other people are buying things, but...other than telling me that you guys are doing business, I'm not sure what utility it has.  

Ways to personalize the content seem like they could be very cool - what if customers are asked to write in some information about what the reason for their purchase is after they buy?  Definitely don't want to get in the way of the purchase, but maybe ways to connect with other users/drivers of similar cars, or just to know what other drivers are doing?  I think there are a lot of possibilities there.
