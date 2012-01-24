require "net/http"
sleep 2
begin
 
    log "@"*5 + "User has answered"
    log "@"*5 + "Session: " + $currentCall.sessionId
 
    #Create second thread for second for timer and announcements
    Thread.new do
        log "@"*5 + "Start second tread"
 
    sleep 600
 
	http = Net::HTTP.new("api.tropo.com")

	request = Net::HTTP::Get.new("/1.0/sessions/#{$currentCall.sessionId}/signals?action=signal&value=limitreached")
	response = http.request(request)
 
  end #thread
 
	# Blocked North American area codes
	blocked = []
	blocked.push(/^\+?1?8[024]9/)
	blocked.push(/^\+?1?26[48]/)
	blocked.push(/^\+?1?24[26]/)
	blocked.push(/^\+?1?34[05]/)
	blocked.push(/^\+?1?[62]84/)
	blocked.push(/^\+?1?67[10]/)
	blocked.push(/^\+?1?78[47]/)
	blocked.push(/^\+?1?8[024]9/)
	blocked.push(/^\+?1?86[89]/)
	blocked.push(/^\+?1?441/)
	blocked.push(/^\+?1?473/)
	blocked.push(/^\+?1?664/)
	blocked.push(/^\+?1?649/)
	blocked.push(/^\+?1?721/)
	blocked.push(/^\+?1?758/)
	blocked.push(/^\+?1?767/)
	blocked.push(/^\+?1?876/)
	blocked.push(/^\+?1?939/)


	phone = $currentCall.getHeader("x-numbertodial").gsub("-","").gsub(".","").gsub(" ", "")
log "@"*5 +phone

	allowcall = true
	blocked.each { |x| 
		if phone =~ x 
			allowcall = false
			log "@"*5 + "Blocked Call"
		end
	}

	if allowcall
	  say "hold please while we transfer your call."
	  transfer phone, { :allowsignals => "limitreached"}
	  say "your limit has been reached."
	else
	  say "calls to this area code are blocked."
	end

end

sleep 2