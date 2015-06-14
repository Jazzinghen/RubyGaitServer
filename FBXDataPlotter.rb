require 'nyaplot'

plot = Nyaplot::Plot.new
bar = plot.add(:bar, ['Persian', 'Maine Coon', 'American Shorthair'], [10,20,30])

plot.show