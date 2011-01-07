require 'stalker'

handler do |job|
	Stalker.enqueue(job)
end

every(1.day, 'feeds.clean', :at => '02:30')
every(1.day, 'feeds.fetch', :at => '02:50')
