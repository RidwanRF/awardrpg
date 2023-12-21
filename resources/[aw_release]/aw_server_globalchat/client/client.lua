local reklamy = {
	"#f2ad4a[Info]#ffffffЕсли вы обнаружили баг, то сообщите о нём в нашу группу ВКонтакте: vk.com/awardmta",
}
 
function getAds ()
	outputChatBox(reklamy[math.random(1, #reklamy)], 255, 255, 255, true)
end
setTimer(getAds, 900000, 2)
setTimer(getAds, 600000, 0)