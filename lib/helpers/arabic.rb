module Helper

  class Arabic

    FATHA = "\u{064E}"
    DAMMA = "\u{064F}"
    KASRA = "\u{0650}"
    TANWEEN_AL_FATH = "\u{064B}"
    TANWEEN_AL_DAM = "\u{064C}"
    TANWEEN_AL_KASR = "\u{064D}"
    SHADDA = "\u{0651}"
    SUKOON = "\u{0652}"
    MADDA = "\u{0653}"
    UPPER_HAMZA = "\u{0654}"
    LOWER_HAMZA = "\u{0655}"
    LETTER_HAMZA = "\u{0621}"
    WAHED = "\u{0661}"
    ITHNAN = "\u{0662}"
    THALATHA = "\u{0663}"
    ARBAA = "\u{0664}"
    KHAMSA = "\u{0665}"
    SITTA = "\u{0666}"
    SABAA = "\u{0667}"
    THAMANIA = "\u{0668}"
    TISA = "\u{0669}"
    SIFR = "\u{0660}"

    def self.tashkeel
      [FATHA, DAMMA, KASRA, TANWEEN_AL_FATH, TANWEEN_AL_DAM, TANWEEN_AL_KASR, SHADDA, SUKOON].join
    end
  end
end
