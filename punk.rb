require 'pixelart'

PARTS = {
  # 'f' stands for female, 'm' stands for male and 'u' stands for unisex
  face:  { required: true,
           attributes: [['', 'u'],
                        ['', 'u']] },
  mouth: { required: true,
           attributes: [['Black Lipstick',  'f'],
                        ['Red Lipstick',    'f'],
                        ['Smile',           'u'],
                        ['',                'u'],
                        ['Teeth Smile',     'm'],
                        ['Purple Lipstick', 'f']] },
  nose:  { required: true,
           attributes: [['',          'u'],
                        ['Nose Ring', 'u']] },
  eyes:  { required: true,
           attributes: [['Asian Eyes',    'u'],
                        ['Sun Glasses',   'u'],
                        ['Red Glasses',   'u'],
                        ['Round Eyes',    'u']] },
  ears:  { required: true,
           attributes: [['',              'u'],
                        ['Left Earring',  'u'],
                        ['Right Earring', 'u'],
                        ['Two Earrings',  'u']] },
  beard: { required: false,
           attributes: [['Brown Beard',     'm'],
                        ['Mustache-Beard',  'm'],
                        ['Mustache',        'm'],
                        ['Regular Beard',   'm']] },
  hair:  { required: false,
           attributes: [['Up Hair',        'm'],
                        ['Down Hair',      'u'],
                        ['Mahawk',         'u'],
                        ['Red Mahawk',     'u'],
                        ['Orange Hair',    'u'],
                        ['Bubble Hair',    'm'],
                        ['Emo Hair',       'u'],
                        ['Thin Hair',      'm'],
                        ['Bald',           'm'],
                        ['Blonde Hair',    'f']] }
}

class Punk
  attr_reader(*PARTS.keys)

  def initialize
    my_sex = [?m, ?f].sample

    PARTS.each do |k, v|
      # randomly skip if not required
      unless v[:required]
        next if [true, false].sample
      end

      # extract part code for my_sex or unisex
      names, sexes = v[:attributes].transpose
      code = (1..sexes.size).zip(sexes).shuffle.find{|_, sex| [my_sex, ?u].include? sex }&.first

      if code
        instance_variable_set("@#{k}", code)

        # for debugging
        puts "#{k}: #{names[code-1]}"
      end
    end
  end

  def save
    punk = Pixelart::Image.new(56, 56)
    PARTS.keys.each do |key|
      code = send(key)

      if code
        part = Pixelart::Image.read("./i/parts/#{key}/#{key}#{code}.png")
        punk.compose!(part)
      end
    end

    punk.save( "punks/punk-#{Dir["punks/**.png"].size}.png")
  end
end