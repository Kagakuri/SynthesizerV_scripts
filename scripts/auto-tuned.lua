--[[
    KeroKeroVoice Script using PitchControlCurve

    Copyright (c) 2026 Kagakuri
    Licensed under the MIT License.

    https://github.com/Kagakuri/SynthesizerV_scripts
]]

function getClientInfo()
    return {
        name = SV:T("ケロケロボイス（PitchControlCurve）"),
        category = "Pitch",
        author = "Kagakuri",
        versionNumber = 7,
        minEditorVersion = 130816 -- v2.1.0 以上
    }
end

function main()
    local selection = SV:getMainEditor():getSelection()
    local selectedNotes = selection:getSelectedNotes()

    if #selectedNotes == 0 then
        SV:finish()
        return
    end

    SV:getProject():newUndoRecord()

    for i = 1, #selectedNotes do
        local note = selectedNotes[i]
        local onset = note:getOnset()
        local duration = note:getDuration()
        local group = note:getParent()

        -- 1. ノートの基本音高（MIDI番号）を取得
        -- Synthesizer V では MIDI 番号 1 = 1半音(semitone)
        local basePitch = note:getPitch()

        -- 2. ノート属性のリセット
        note:setAttributes({
            dF0Vbr = 0,
            dF0Left = 0,
            dF0Right = 0,
            tF0Left = 0,
            tF0Right = 0,
            dF0VbrMod = 0
        })

        -- 3. PitchControlCurve の作成
        local curve = SV:create("PitchControlCurve")

        -- 開始位置をノートのオンセットに設定
        curve:setPosition(onset)

        -- アンカーピッチをノートの基本音高に設定
        curve:setPitch(basePitch)

        -- ノートの開始から終了までオフセット 0 (＝basePitchのまま) で固定
        curve:setPoints({
            {0, 0},
            {duration, 0}
        })

        -- 4. ノートグループにピッチ制御を追加
        group:addPitchControl(curve)
    end

    SV:finish()
end
