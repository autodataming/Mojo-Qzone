 "http://boss.qzone.qq.com/fcg-bin/fcg_get_strategy?board_id=2365&uin=1017044504"
 "http://boss.qzone.qq.com/fcg-bin/fcg_get_strategy?board_id=2365&uin=1017044504"
 5
 skey  p_skey
 p_skey
  if (!skey)
            skey = QZFL.cookie.get("p_skey") || (QZFL.cookie.get("skey") || (QZFL.cookie.get("rv2") || ""));
 "6aqOr4se9rofWDBUlzNTqur-WlytCRjxPH4l6LDnNwc_"
 "6aqOr4se9rofWDBUlzNTqur-WlytCRjxPH4l6LDnNwc_"
 1007832691
 1007832691
 QZFL.pluginsDefine.getACSRFToken = function(url) {
 	
 	
 	 QZFL.pluginsDefine.getACSRFToken._DJB = function(str) {
        var hash = 5381;
        for (var i = 0, len = str.length; i < len; ++i)
            hash += (hash << 5) + str.charCodeAt(i);
        return hash & 2147483647
    }
    
    function  encrypt(skey)
    {
    	  var hash = 5381;
        for (var i = 0, len = skey.length; i < len; ++i)
            hash += (hash << 5) + skey.charCodeAt(i);
        return hash & 2147483647
    	
    }