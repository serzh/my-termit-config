require("termit.colormaps")
require("termit.utils")

defaults = {}
defaults.windowTitle = 'Termit'
defaults.tabName = 'Terminal'
defaults.encoding = 'UTF-8'
defaults.wordChars = '+-AA-Za-z0-9,./?%&#:_~'
defaults.font = 'Monospace 10'
--defaults.foregroundColor = 'gray'
--defaults.backgroundColor = 'black'
defaults.showScrollbar = false
defaults.transparency = 0
--defaults.imageFile = '/tmp/img.png'
defaults.hideSingleTab = true
defaults.hideMenubar = true
--defaults.fillTabbar = false
defaults.fillTabbar = false
defaults.scrollbackLines = 2^16
defaults.geometry = '80x24'
defaults.allowChangingTitle = true
--defaults.backspaceBinding = 'AsciiBksp'
--defaults.deleteBinding = 'AsciiDel'
defaults.setStatusbar = function (tabInd)
    tab = tabs[tabInd]
    if tab then
        return tab.encoding..'  Bksp: '..tab.backspaceBinding..'  Del: '..tab.deleteBinding
    end
    return ''
end
--defaults.changeTitle = function (title)
--    print('title='..title)
--    newTitle = 'Termit: '..title
--    return newTitle
--end
defaults.colormap = termit.colormaps.delicate
defaults.matches = {['http.*'] = function (url) print('Matching url: '..url) end}
--defaults.tabs = {{title = 'Test new tab 1'; workingDir = '/tmp'};
    --{title = 'Test new tab 2'; workingDir = '/tmp'}}
setOptions(defaults)

bindKey('Ctrl-Page_Up', prevTab)
bindKey('Ctrl-Page_Down', nextTab)
bindKey('Ctrl-F', findDlg)
bindKey('Ctrl-2', function () print('Hello2!') end)
bindKey('Ctrl-3', function () print('Hello3!') end)
bindKey('Ctrl-3', nil) -- remove previous binding

bindKey('Alt-1', function() activateTab(1) end)
bindKey('Alt-2', function() activateTab(2) end)
bindKey('Alt-3', function() activateTab(3) end)
bindKey('Alt-4', function() activateTab(4) end)
bindKey('Alt-5', function() activateTab(5) end)
bindKey('Alt-6', function() activateTab(6) end)
bindKey('Alt-7', function() activateTab(7) end)

-- don't close tab with Ctrl-w, use CtrlShift-w
bindKey('Ctrl-w', nil)
bindKey('CtrlShift-w', closeTab)

setKbPolicy('keycode')

-- bind double click to close tab
bindMouse('DoubleClick', closeTab)

-- 
userMenu = {}
table.insert(userMenu, {name='Close tab', action=closeTab})
table.insert(userMenu, {name='New tab name', action=function () setTabTitle('New tab name') end})

mi = {}
mi.name = 'Zsh tab'
mi.action = function ()
    tabInfo = {}
    tabInfo.title = 'Zsh tab'
    tabInfo.command = 'zsh'
    tabInfo.encoding = 'UTF-8'
    tabInfo.workingDir = '/tmp'
    tabInfo.backspaceBinding = 'AsciiBksp'
    tabInfo.deleteBinding = 'EraseDel'
    openTab(tabInfo)
end
table.insert(userMenu, mi)

table.insert(userMenu, {name='set red color', action=function () setTabForegroundColor('red') end})
table.insert(userMenu, {name='Reconfigure', action=reconfigure, accel='Ctrl-r'})
table.insert(userMenu, {name='Selection', action=function () print(selection()) end})
table.insert(userMenu, {name='dumpAllRows', action=function () forEachRow(print) end})
table.insert(userMenu, {name='dumpVisibleRowsToFile',
    action=function () termit.utils.dumpToFile(forEachVisibleRow, '/tmp/termit.dump') end})
table.insert(userMenu, {name='findNext', action=findNext, accel='Alt-n'})
table.insert(userMenu, {name='findPrev', action=findPrev, accel='Alt-p'})
table.insert(userMenu, {name='new colormap', action=function () setColormap(termit.colormaps.mikado) end})

mi = {}
mi.name = 'Get tab info'
mi.action = function ()
    tab = tabs[currentTabIndex()]
    if tab then
        termit.utils.printTable(tab, '  ')
    end
end
table.insert(userMenu, mi)

function changeTabFontSize(delta)
    tab = tabs[currentTabIndex()]
    setTabFont(string.sub(tab.font, 1, string.find(tab.font, '%d+$') - 1)..(tab.fontSize + delta))
end

table.insert(userMenu, {name='Increase font size', action=function () changeTabFontSize(1) end})
table.insert(userMenu, {name='Decrease font size', action=function () changeTabFontSize(-1) end})
table.insert(userMenu, {name='feed example', action=function () feed('example') end})
table.insert(userMenu, {name='feedChild example', action=function () feedChild('date\n') end})
table.insert(userMenu, {name='User quit', action=quit})

addMenu(userMenu, "User menu")
addPopupMenu(userMenu, "User menu")

addMenu(termit.utils.encMenu(), "Encodings")
addPopupMenu(termit.utils.encMenu(), "Encodings")

