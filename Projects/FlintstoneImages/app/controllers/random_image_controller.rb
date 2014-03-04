class RandomImageController < ApplicationController
  def display
    # Pick random number from 1 to 4 inclusive.
    i = 1 + rand(4)
    # Choose image and name that corresponds 
    # to the random number.
    if i == 1
      @img = 'fred-flintstone.gif'
      @name = 'Fred Flintstone'
      @desc = "Fred is married to Wilma.  He has a pet dinosaur named Dino.  He is friends with Barney and enjoys yelling and going to work"
      @pstyle = "a"
    elsif i == 2
      @img = 'wilma-flintstone.jpg'
      @name = 'Wilma Flintstone'
      @desc = "Wilma is overly kinds to Fred and a loving mother.  She wears the same outfit every day but it doesn't bother anyone.  One day we all hope she will discover that Fred is a complete idiot... or has she already?  Stay tuned to find out!"
      @pstyle = "b"
    elsif i == 3
      @img = 'barney-rubble.png'
      @name = 'Barney Rubble'
      @desc = "Barney works at the quarry with Fred.  He is married to Betty and has a son named Bam Bam.  His life expectancy is about age 23."
      @pstyle = "c"
    else
      @img = 'betty-rubble.jpg'
      @name = 'Betty Rubble'
      @desc = "Betty lives in the stone age with her husband Barney.  She has excellent style and enjoys playing bridge and being with her family.  She is still amazed whenever fire is present in the room"
      @pstyle = "d"
    end
  end
end
