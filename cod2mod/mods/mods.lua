WHITE_TXD = engineLoadTXD("mods/soldier_white.txd")
engineImportTXD(WHITE_TXD, 287)
WHITE_DFF = engineLoadDFF("mods/soldier_white.dff", 0)
engineReplaceModel(WHITE_DFF, 287)

BLACK_TXD = engineLoadTXD("mods/soldier_black.txd")
engineImportTXD(BLACK_TXD, 285)
BLACK_DFF = engineLoadDFF("mods/soldier_black.dff", 0)
engineReplaceModel(BLACK_DFF, 285)

WHITE_FLAG = engineLoadTXD("txd/goflagx.txd")
engineImportTXD(WHITE_FLAG, 2993)

BLACK_FLAG = engineLoadTXD("txd/rcflagx.txd")
engineImportTXD(BLACK_FLAG, 2914)

MEDICBAG = engineLoadTXD("txd/dyn_drugs.txd")
engineImportTXD(MEDICBAG, 1575)

--[[txd_1082 = engineLoadTXD("txd/mp5.txd")
engineImportTXD(txd_1082, 353)
dff_1082 = engineLoadDFF("txd/mp5.dff", 0)
engineReplaceModel(dff_1082, 353)]]--