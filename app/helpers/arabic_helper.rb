module ArabicHelper

  FATHA = "\u{064E}" # َ
  DAMMA = "\u{064F}" # ُ
  KASRA = "\u{0650}" #ِ
  TANWEEN_AL_FATH = "\u{064B}" # ً
  TANWEEN_AL_DAM = "\u{064C}" # ٌ
  TANWEEN_AL_KASR = "\u{064D}" # ٍ
  SHADDA = "\u{0651}" # ّ
  SUKOON = "\u{0652}" # ْ
  MADDA = "\u{0653}" # آ
  UPPER_HAMZA = "\u{0654}" # أ
  LOWER_HAMZA = "\u{0655}" # إ
  LETTER_HAMZA = "\u{0621}" # ء
  WAHED = "\u{0661}" # ١
  ITHNAN = "\u{0662}" # ٢
  THALATHA = "\u{0663}" # ٣
  ARBAA = "\u{0664}" # ٤
  KHAMSA = "\u{0665}" # ٥
  SITTA = "\u{0666}" # ٦
  SABAA = "\u{0667}" # ٧
  THAMANIA = "\u{0668}" # ٨
  TISA = "\u{0669}" # ٩
  SIFR = "\u{0660}" # ٠

  LETTER_ALTERS = {
    'ا' => ['أ', 'آ', 'إ', 'ى'],
    'أ' => ['ا', 'آ', 'إ'],
    'آ' => ['أ', 'ا', 'إ'],
    'إ' => ['أ', 'آ', 'ا'],
    'ي' => ['ى', 'ئ'],
    'ى' => ['ي', 'ئ'],
    'ة' => ['ه'],
    'ه' => ['ة'],
    'و' => ['ؤ'],
    'ؤ' => ['و']
  }

  def tashkeel
    [FATHA, DAMMA, KASRA, TANWEEN_AL_FATH, TANWEEN_AL_DAM, TANWEEN_AL_KASR, SHADDA, SUKOON].join
  end

  def letter_alter letter
    return [letter] + LETTER_ALTERS[letter] if LETTER_ALTERS[letter]
    [letter]
  end

  def encode string
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    ic.iconv(string)
  end
end
