--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 09/05/2017
-- Time: 09:55
-- To change this template use File | Settings | File Templates.
--
server_scripts {
    '../../essentialmode/config.lua',
    'server.lua'
}
client_script {
    'client.lua',
    'GUI.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/ci_h.png',
	'html/ci_f.png',
	'html/cursor.png'
}

export 'getQuantity'
export 'notFull'