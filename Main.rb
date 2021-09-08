require 'rubygems'
require 'gosu'

include Gosu


class GameWindow < Gosu::Window
	
	WIDTH = 800
	HEIGHT = 600
	TITLE = "Checkers"
	
	attr_reader :circle_img, :font, :point_img
	
	def initialize
		
		super(WIDTH, HEIGHT, false)
		self.caption = TITLE
		
		$window_width = WIDTH
		$window_height = HEIGHT
		
		@circle_img = Gosu::Image.new(self, "circle.png", true)
		@point_img = Gosu::Image.new(self, "Point2.png", true)
		@logo_img = Gosu::Image.new(self, "logo.png", true)
		
		@font = Gosu::Font.new(self, Gosu::default_font_name, 17)
		@bigfont = Gosu::Font.new(self, Gosu::default_font_name, 20)
		
		$menu = true
		$map = false
		$show_targets = false
		$ai_only = false
		
		### What colour is controled by the ai
		$ais = ["blue", "green", "orange", "gray", "magenta"]
		# $ais = []
		
		$qpressed = false  ## debugging
		
	end
	
	def create_checker(x, y, team)
		inst = Checker.new(self, x, y, team)
		$checkers << inst
	end
	
	def create_tile(x, y, col)
		inst = Tile.new(self, x, y, col)
		$tiles << inst
	end
	
	def load_map
		
		$menu = false
		$animating = false
		$animation_speed_max = 5   ### Smaller means faster
		$animation_speed = $animation_speed_max
		$animating_inst = false
		
		## Showing the fitness of each ai/player
		$fit_red = []
		$fit_blue = []
		$fit_green = []
		$fit_orange = []
		$fit_gray = []
		$fit_magenta = []
		
		if $ai_only == true
			$ais << "red"
		end
		
		if $map == "2 players"
			
			$gridsize = 32
			
			$x_offset = $window_width/2
			$y_offset = $window_height/2
			
			$tiles = []
			$checkers = []
			$selection = false
			
			$teams = ["red", "blue"]
			$team_turn = $teams[0]
			
			self.create_checker(-3, -3, "red")
			self.create_checker(-3, -2, "red")
			self.create_checker(-2, -3, "red")
			self.create_checker(-2, -2, "red")
			self.create_checker(-3, -1, "red")
			self.create_checker(-1, -3, "red")
			
			self.create_checker(3, 3, "blue")
			self.create_checker(3, 2, "blue")
			self.create_checker(2, 3, "blue")
			self.create_checker(2, 2, "blue")
			self.create_checker(3, 1, "blue")
			self.create_checker(1, 3, "blue")
			
			for i in -3..3
				for e in -3..3
					self.create_tile(i, e, 0xff000000)
				end
			end
			
		elsif $map == "3 players"
			
			$gridsize = 32
			
			$x_offset = $window_width/2
			$y_offset = $window_height/2
			
			$tiles = []
			$checkers = []
			$selection = false
			
			$teams = ["red", "blue", "green"]
			$team_turn = $teams[0]
			
			for i in -5..4
				for e in i..4
					tx = -e+1
					ty = i+2
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
					tx = e-1
					ty = i-e+3
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
				end
			end
			
			self.create_checker(-3, -3, "red")
			self.create_checker(-3, -2, "red")
			self.create_checker(-2, -3, "red")
			self.create_checker(-2, -2, "red")
			self.create_checker(-3, -1, "red")
			self.create_checker(-1, -3, "red")
			
			self.create_checker(6, -3, "blue")
			self.create_checker(5, -3, "blue")
			self.create_checker(4, -3, "blue")
			self.create_checker(5, -2, "blue")
			self.create_checker(4, -2, "blue")
			self.create_checker(4, -1, "blue")
			
			self.create_checker(-3, 6, "green")
			self.create_checker(-2, 5, "green")
			self.create_checker(-3, 5, "green")
			self.create_checker(-1, 4, "green")
			self.create_checker(-2, 4, "green")
			self.create_checker(-3, 4, "green")
		
		elsif $map == "3 players big"
			
			$gridsize = 28
			
			$x_offset = $window_width/2
			$y_offset = $window_height/2
			
			$tiles = []
			$checkers = []
			$selection = false
			
			$teams = ["red", "blue", "green"]
			$team_turn = $teams[0]
			
			for i in -8..7
				for e in i..4
					tx = -e
					ty = i+4
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
					tx = e
					ty = i-e+4
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
				end
			end
			
			self.create_checker(-4, -4, "red")
			self.create_checker(-3, -4, "red")
			self.create_checker(-2, -4, "red")
			self.create_checker(-1, -4, "red")
			self.create_checker(-4, -3, "red")
			self.create_checker(-3, -3, "red")
			self.create_checker(-2, -3, "red")
			self.create_checker(-4, -2, "red")
			self.create_checker(-3, -2, "red")
			self.create_checker(-4, -1, "red")
			
			self.create_checker(8, -4, "blue")
			self.create_checker(7, -4, "blue")
			self.create_checker(6, -4, "blue")
			self.create_checker(5, -4, "blue")
			self.create_checker(5, -3, "blue")
			self.create_checker(6, -3, "blue")
			self.create_checker(7, -3, "blue")
			self.create_checker(5, -2, "blue")
			self.create_checker(6, -2, "blue")
			self.create_checker(5, -1, "blue")
			
			self.create_checker(-4, 8, "green")
			self.create_checker(-4, 7, "green")
			self.create_checker(-4, 6, "green")
			self.create_checker(-4, 5, "green")
			self.create_checker(-3, 5, "green")
			self.create_checker(-3, 6, "green")
			self.create_checker(-3, 7, "green")
			self.create_checker(-2, 5, "green")
			self.create_checker(-2, 6, "green")
			self.create_checker(-1, 5, "green")
			
		elsif $map == "3 players bigger"
			
			$gridsize = 28
			
			$x_offset = $window_width/2
			$y_offset = $window_height/2
			
			$tiles = []
			$checkers = []
			$selection = false
			
			$teams = ["red", "blue", "green"]
			$team_turn = $teams[0]
			
			for i in -11..10
				for e in i..4
					tx = -e-1
					ty = i+6
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
					tx = e+1
					ty = i-e+5
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
				end
			end
			
			self.create_checker(-5, -5, "red")
			self.create_checker(-4, -5, "red")
			self.create_checker(-3, -5, "red")
			self.create_checker(-2, -5, "red")
			self.create_checker(-1, -5, "red")
			self.create_checker(-5, -4, "red")
			self.create_checker(-4, -4, "red")
			self.create_checker(-3, -4, "red")
			self.create_checker(-2, -4, "red")
			self.create_checker(-5, -3, "red")
			self.create_checker(-4, -3, "red")
			self.create_checker(-3, -3, "red")
			self.create_checker(-5, -2, "red")
			self.create_checker(-4, -2, "red")
			self.create_checker(-5, -1, "red")
			
			self.create_checker(10, -5, "blue")
			self.create_checker(9, -5, "blue")
			self.create_checker(8, -5, "blue")
			self.create_checker(7, -5, "blue")
			self.create_checker(6, -5, "blue")
			self.create_checker(6, -4, "blue")
			self.create_checker(7, -4, "blue")
			self.create_checker(8, -4, "blue")
			self.create_checker(9, -4, "blue")
			self.create_checker(6, -3, "blue")
			self.create_checker(7, -3, "blue")
			self.create_checker(8, -3, "blue")
			self.create_checker(6, -2, "blue")
			self.create_checker(7, -2, "blue")
			self.create_checker(6, -1, "blue")
			
			self.create_checker(-5, 10, "green")
			self.create_checker(-5, 9, "green")
			self.create_checker(-5, 8, "green")
			self.create_checker(-5, 7, "green")
			self.create_checker(-5, 6, "green")
			self.create_checker(-4, 6, "green")
			self.create_checker(-4, 7, "green")
			self.create_checker(-4, 8, "green")
			self.create_checker(-4, 9, "green")
			self.create_checker(-3, 6, "green")
			self.create_checker(-3, 7, "green")
			self.create_checker(-3, 8, "green")
			self.create_checker(-2, 6, "green")
			self.create_checker(-2, 7, "green")
			self.create_checker(-1, 6, "green")
			
		elsif $map == "6 players"
			
			$gridsize = 32
			
			$x_offset = $window_width/2
			$y_offset = $window_height/2
			
			$tiles = []
			$checkers = []
			$selection = false
			
			$teams = ["red", "blue", "green", "orange", "gray", "magenta"]
			$team_turn = $teams[0]
			
			for i in -5..4
				for e in i..4
					tx = -e+1
					ty = i+2
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
					tx = e-1
					ty = i-e+3
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
				end
			end
			
			self.create_checker(-3, -3, "red")
			self.create_checker(-3, -2, "red")
			self.create_checker(-2, -3, "red")
			self.create_checker(-2, -2, "red")
			self.create_checker(-3, -1, "red")
			self.create_checker(-1, -3, "red")
			
			self.create_checker(6, -3, "blue")
			self.create_checker(5, -3, "blue")
			self.create_checker(4, -3, "blue")
			self.create_checker(5, -2, "blue")
			self.create_checker(4, -2, "blue")
			self.create_checker(4, -1, "blue")
			
			self.create_checker(-3, 6, "green")
			self.create_checker(-2, 5, "green")
			self.create_checker(-3, 5, "green")
			self.create_checker(-1, 4, "green")
			self.create_checker(-2, 4, "green")
			self.create_checker(-3, 4, "green")
			
			self.create_checker(3, 3, "orange")
			self.create_checker(2, 3, "orange")
			self.create_checker(1, 3, "orange")
			self.create_checker(3, 2, "orange")
			self.create_checker(2, 2, "orange")
			self.create_checker(3, 1, "orange")
			
			self.create_checker(-6, 3, "gray")
			self.create_checker(-5, 3, "gray")
			self.create_checker(-4, 3, "gray")
			self.create_checker(-5, 2, "gray")
			self.create_checker(-4, 2, "gray")
			self.create_checker(-4, 1, "gray")
			
			self.create_checker(3, -6, "magenta")
			self.create_checker(3, -5, "magenta")
			self.create_checker(3, -4, "magenta")
			self.create_checker(2, -5, "magenta")
			self.create_checker(2, -4, "magenta")
			self.create_checker(1, -4, "magenta")
		
		elsif $map == "6 players bigger"
			
			$gridsize = 28
			
			$x_offset = $window_width/2
			$y_offset = $window_height/2
			
			$tiles = []
			$checkers = []
			$selection = false
			
			$teams = ["red", "blue", "green", "orange", "gray", "magenta"]
			$team_turn = $teams[0]
			
			for i in -11..10
				for e in i..4
					tx = -e-1
					ty = i+6
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
					tx = e+1
					ty = i-e+5
					if tile_exists(tx, ty) == false
						self.create_tile(tx, ty, 0xff000000)
					end
				end
			end
			
			self.create_checker(-5, -5, "red")
			self.create_checker(-4, -5, "red")
			self.create_checker(-3, -5, "red")
			self.create_checker(-2, -5, "red")
			self.create_checker(-1, -5, "red")
			self.create_checker(-5, -4, "red")
			self.create_checker(-4, -4, "red")
			self.create_checker(-3, -4, "red")
			self.create_checker(-2, -4, "red")
			self.create_checker(-5, -3, "red")
			self.create_checker(-4, -3, "red")
			self.create_checker(-3, -3, "red")
			self.create_checker(-5, -2, "red")
			self.create_checker(-4, -2, "red")
			self.create_checker(-5, -1, "red")
			
			self.create_checker(10, -5, "blue")
			self.create_checker(9, -5, "blue")
			self.create_checker(8, -5, "blue")
			self.create_checker(7, -5, "blue")
			self.create_checker(6, -5, "blue")
			self.create_checker(6, -4, "blue")
			self.create_checker(7, -4, "blue")
			self.create_checker(8, -4, "blue")
			self.create_checker(9, -4, "blue")
			self.create_checker(6, -3, "blue")
			self.create_checker(7, -3, "blue")
			self.create_checker(8, -3, "blue")
			self.create_checker(6, -2, "blue")
			self.create_checker(7, -2, "blue")
			self.create_checker(6, -1, "blue")
			
			self.create_checker(-5, 10, "green")
			self.create_checker(-5, 9, "green")
			self.create_checker(-5, 8, "green")
			self.create_checker(-5, 7, "green")
			self.create_checker(-5, 6, "green")
			self.create_checker(-4, 6, "green")
			self.create_checker(-4, 7, "green")
			self.create_checker(-4, 8, "green")
			self.create_checker(-4, 9, "green")
			self.create_checker(-3, 6, "green")
			self.create_checker(-3, 7, "green")
			self.create_checker(-3, 8, "green")
			self.create_checker(-2, 6, "green")
			self.create_checker(-2, 7, "green")
			self.create_checker(-1, 6, "green")
			
			self.create_checker(5, 5, "orange")
			self.create_checker(4, 5, "orange")
			self.create_checker(3, 5, "orange")
			self.create_checker(2, 5, "orange")
			self.create_checker(1, 5, "orange")
			self.create_checker(5, 4, "orange")
			self.create_checker(4, 4, "orange")
			self.create_checker(3, 4, "orange")
			self.create_checker(2, 4, "orange")
			self.create_checker(5, 3, "orange")
			self.create_checker(4, 3, "orange")
			self.create_checker(3, 3, "orange")
			self.create_checker(5, 2, "orange")
			self.create_checker(4, 2, "orange")
			self.create_checker(5, 1, "orange")
			
			self.create_checker(-10, 5, "gray")
			self.create_checker(-9, 5, "gray")
			self.create_checker(-8, 5, "gray")
			self.create_checker(-7, 5, "gray")
			self.create_checker(-6, 5, "gray")
			self.create_checker(-6, 4, "gray")
			self.create_checker(-7, 4, "gray")
			self.create_checker(-8, 4, "gray")
			self.create_checker(-9, 4, "gray")
			self.create_checker(-6, 3, "gray")
			self.create_checker(-7, 3, "gray")
			self.create_checker(-8, 3, "gray")
			self.create_checker(-6, 2, "gray")
			self.create_checker(-7, 2, "gray")
			self.create_checker(-6, 1, "gray")
			
			self.create_checker(5, -10, "magenta")
			self.create_checker(5, -9, "magenta")
			self.create_checker(5, -8, "magenta")
			self.create_checker(5, -7, "magenta")
			self.create_checker(5, -6, "magenta")
			self.create_checker(4, -6, "magenta")
			self.create_checker(4, -7, "magenta")
			self.create_checker(4, -8, "magenta")
			self.create_checker(4, -9, "magenta")
			self.create_checker(3, -6, "magenta")
			self.create_checker(3, -7, "magenta")
			self.create_checker(3, -8, "magenta")
			self.create_checker(2, -6, "magenta")
			self.create_checker(2, -7, "magenta")
			self.create_checker(1, -6, "magenta")
			
		end
		
		puts "Tiles: #{$tiles.length}"
		
		if $ais.empty? == false
			for i in 0..$ais.length-1
				if $team_turn == $ais[i]
					self.check_ai_turn($ais[i])
					break
				end
			end
		end
		
	end
	
	def update
		if $animating == true
			$animation_speed = [0, $animation_speed-1].max
			if $animation_speed == 0
				if $moves.length <= 2
					# $animating_inst.stop_animating
					$checkers.each { |inst|  inst.stop_animating }
					$animating = false
					$animation_speed = $animation_speed_max
					
					# puts $team_turn
					
					## Run ai turn if there are any
					if $ais.empty? == false
						for i in 0..$ais.length-1
							if $team_turn == $ais[i]
								self.check_ai_turn($ais[i])
								break
							end
						end
					end
					
				else
					$moves.shift
					$animation_speed = $animation_speed_max
				end
			end
		end
		
		self.caption = "Checkers v 0.3  -  [FPS: #{Gosu::fps.to_s}]"
	end
	
	def button_down(id)
		case id
			when Gosu::KbEscape
				close
			when Gosu::KbQ
				## Placeholder
				$qpressed = !$qpressed
				
			when Gosu::MsLeft
				if $menu == true
					
					## Ai only Button
					a = 20
					b = 150
					c = 120
					d = 180
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$ai_only = !$ai_only
					end
					
					## 1v1 Button
					a = $window_width/2-65
					b = 150
					c = $window_width/2+65
					d = 180
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$map = "2 players"
						self.load_map
					end
					
					## 1v1v1 Button
					a = $window_width/2-65
					b = 200
					c = $window_width/2+65
					d = 230
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$map = "3 players"
						self.load_map
					end
					
					## 1v1v1 big Button
					a = $window_width/2-65
					b = 250
					c = $window_width/2+65
					d = 280
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$map = "3 players big"
						self.load_map
					end
					
					## 1v1v1 bigger Button
					a = $window_width/2-65
					b = 300
					c = $window_width/2+65
					d = 330
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$map = "3 players bigger"
						self.load_map
					end
					
					## 6 players crowded
					a = $window_width/2-65
					b = 350
					c = $window_width/2+65
					d = 380
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$map = "6 players"
						self.load_map
					end
					
					## 6 players bigger
					a = $window_width/2-65
					b = 400
					c = $window_width/2+65
					d = 430
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$map = "6 players bigger"
						self.load_map
					end
					
				else
					
					## Back Button
					a = 10
					b = $window_height-40
					c = 80
					d = $window_height-10
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$menu = true
						$map = false
						$animating = false
						$animation_speed = $animation_speed_max
						$animating_inst = false
					end
					
					## Show targets Button
					a = 95
					b = $window_height-40
					c = 200
					d = $window_height-10
					if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
						$show_targets = !$show_targets
					end
					
					if $animating == false
						if $selection == false
							$checkers.each { |inst|  inst.check_selected(mouse_x, mouse_y) }
						else
							$selection.check_mouse_pressed(mouse_x, mouse_y)
						end
					end
					
				end
		end
	end
	
	def draw
		
		## Background
		color = 0xffFFeedd
		self.draw_quad(0, 0, color, $window_width, 0, color, $window_width, $window_height, color, 0, $window_height, color, 0)
		
		if $menu == false
			
			$checkers.each { |inst|  inst.draw }
			$tiles.each    { |inst|  inst.draw }
			
			## Back Button
			a = 10
			b = $window_height-40
			c = 80
			d = $window_height-10
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("Back", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			## Show targets Button
			a = 95
			b = $window_height-40
			c = 200
			d = $window_height-10
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("Show goal", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			@font.draw("Press Q for debugging", 600, 10, 11, 1.0, 1.0, 0xff000000)
			
			## Team turn
			if $team_turn == "red"
				@bigfont.draw("Red players turn", $window_width/2-60, 20, 11, 1.0, 1.0, 0xffff0000)
			elsif $team_turn == "blue"
				@bigfont.draw("Blue players turn", $window_width/2-60, 20, 11, 1.0, 1.0, 0xff0000ff)
			elsif $team_turn == "green"
				@bigfont.draw("Green players turn", $window_width/2-60, 20, 11, 1.0, 1.0, 0xff00cc00)
			elsif $team_turn == "orange"
				@bigfont.draw("Orange players turn", $window_width/2-60, 20, 11, 1.0, 1.0, 0xffffcc00)
			elsif $team_turn == "gray"
				@bigfont.draw("Gray players turn", $window_width/2-60, 20, 11, 1.0, 1.0, 0xff888888)
			elsif $team_turn == "magenta"
				@bigfont.draw("Magenta players turn", $window_width/2-60, 20, 11, 1.0, 1.0, 0xffff00ff)
			end
			
			if $qpressed == true
				
				ary = [$fit_red.length, $fit_blue.length, $fit_green.length, $fit_orange.length, $fit_gray.length, $fit_magenta.length]
				tlength = ary.max
				
				fitness_min = 10
				
				case $map
					when "2 players"
						fitness_min = 248
					when "3 players"
						fitness_min = 248
					when "3 players big"
						fitness_min = 533
					when "3 players bigger"
						fitness_min = 1056
					when "6 players"
						fitness_min = 248
					when "6 players bigger"
						fitness_min = 1056
				end
				
				for i in 0..tlength-1
					
					inc = 290.0/tlength
					
					xx = 10+i*inc
					
					if $fit_red[i] != nil
						maxfit = $fit_red.max
						yy = 10+200-($fit_red[i]-fitness_min)*(200.0/(maxfit-fitness_min))
						point_img.draw_rot(xx, yy, 20, 0, 0.5, 0.5, 0.6, 0.6, 0xffff0000)
					end
					
					if $fit_blue[i] != nil
						maxfit = $fit_blue.max
						yy = 10+200-($fit_blue[i]-fitness_min)*(200.0/(maxfit-fitness_min))
						point_img.draw_rot(xx, yy, 20, 0, 0.5, 0.5, 0.6, 0.6, 0xff0000ff)
					end
					
					if $fit_green[i] != nil
						maxfit = $fit_green.max
						yy = 10+200-($fit_green[i]-fitness_min)*(200.0/(maxfit-fitness_min))
						point_img.draw_rot(xx, yy, 20, 0, 0.5, 0.5, 0.6, 0.6, 0xff00cc00)
					end
					
					if $fit_orange[i] != nil
						maxfit = $fit_orange.max
						yy = 10+200-($fit_orange[i]-fitness_min)*(200.0/(maxfit-fitness_min))
						point_img.draw_rot(xx, yy, 20, 0, 0.5, 0.5, 0.6, 0.6, 0xffffcc00)
					end
					
					if $fit_gray[i] != nil
						maxfit = $fit_gray.max
						yy = 10+200-($fit_gray[i]-fitness_min)*(200.0/(maxfit-fitness_min))
						point_img.draw_rot(xx, yy, 20, 0, 0.5, 0.5, 0.6, 0.6, 0xff888888)
					end
					
					if $fit_magenta[i] != nil
						maxfit = $fit_magenta.max
						yy = 10+200-($fit_magenta[i]-fitness_min)*(200.0/(maxfit-fitness_min))
						point_img.draw_rot(xx, yy, 20, 0, 0.5, 0.5, 0.6, 0.6, 0xffff00ff)
					end
					
				end
				
				self.draw_line(10, 10+200, 0xff000000, 300, 10+200, 0xff000000, 20)
				
			end
			
			
			
			if $show_targets == true
				
				triangles = []
				
				if $map == "2 players"
					
					#### [color, x1, y1, x2, y2, x3, y3, orientation]
					triangles << [0x33ff0000, 3.5, 3.5, 0, 3.5, 3.5, 0, "right"]
					triangles << [0x330000ff, -3.5, -3.5, 0, -3.5, -3.5, 0, "left"]
				
				elsif $map == "3 players"
					
					#### [color, x1, y1, x2, y2, x3, y3, orientation]
					triangles << [0x33ff0000, 3.5, 3.5, 0, 3.5, 3.5, 0, "right"]
					triangles << [0x330000ff, -3.5, 3.5, -7, 3.5, -3.5, 0, "right"]
					triangles << [0x3300cc00, 3.5, -3.5, 0, -3.5, 3.5, -7, "right"]
				
				elsif $map == "3 players big"
					
					#### [color, x1, y1, x2, y2, x3, y3, orientation]
					triangles << [0x44ff0000, 4.5, 4.5, 0, 4.5, 4.5, 0, "right"]
					triangles << [0x440000ff, -4.5, 4.5, -9, 4.5, -4.5, 0, "right"]
					triangles << [0x4400cc00, 4.5, -4.5, 0, -4.5, 4.5, -9, "right"]
					
				elsif $map == "3 players bigger"
					
					#### [color, x1, y1, x2, y2, x3, y3, orientation]
					triangles << [0x44ff0000, 5.5, 5.5, 0, 5.5, 5.5, 0, "right"]
					triangles << [0x440000ff, -5.5, 5.5, -11, 5.5, -5.5, 0, "right"]
					triangles << [0x4400cc00, 5.5, -5.5, 0, -5.5, 5.5, -11, "right"]
					
				elsif $map == "6 players"
					
					#### [color, x1, y1, x2, y2, x3, y3, orientation]
					triangles << [0x44ff0000, 3.5, 3.5, 0, 3.5, 3.5, 0, "right"]
					triangles << [0x440000ff, -3.5, 3.5, -7, 3.5, -3.5, 0, "right"]
					triangles << [0x4400cc00, 3.5, -3.5, 0, -3.5, 3.5, -7, "right"]
					triangles << [0x44ffcc00, -3.5, -3.5, 0, -3.5, -3.5, 0, "left"]
					triangles << [0x44888888, 3.5, -3.5, 7, -3.5, 3.5, 0, "left"]
					triangles << [0x44ff00ff, -3.5, 3.5, 0, 3.5, -3.5, 7, "left"]
				
				elsif $map == "6 players bigger"
					
					#### [color, x1, y1, x2, y2, x3, y3, orientation]
					triangles << [0x44ff0000, 5.5, 5.5, 0, 5.5, 5.5, 0, "right"]
					triangles << [0x440000ff, -5.5, 5.5, -11, 5.5, -5.5, 0, "right"]
					triangles << [0x4400cc00, 5.5, -5.5, 0, -5.5, 5.5, -11, "right"]
					triangles << [0x44ffcc00, -5.5, -5.5, 0, -5.5, -5.5, 0, "left"]
					triangles << [0x44888888, 5.5, -5.5, 11, -5.5, 5.5, 0, "left"]
					triangles << [0x44ff00ff, -5.5, 5.5, 0, 5.5, -5.5, 11, "left"]
					
				end
				
				cc = 0xffFFeedd
				
				if triangles.empty? == false
					for i in 0..triangles.length-1
						
						c = triangles[i][0]
						
						if triangles[i][7] == "right"
							x1 = $x_offset + Gosu::offset_x(120, $gridsize*triangles[i][1]) + Gosu::offset_x(60, $gridsize*triangles[i][2])
							y1 = $y_offset + Gosu::offset_y(120, $gridsize*triangles[i][1]) + Gosu::offset_y(60, $gridsize*triangles[i][2])
							xx1 = $x_offset + Gosu::offset_x(120, $gridsize*(triangles[i][1]-0.1)) + Gosu::offset_x(60, $gridsize*(triangles[i][2]-0.1))
							yy1 = $y_offset + Gosu::offset_y(120, $gridsize*(triangles[i][1]-0.1)) + Gosu::offset_y(60, $gridsize*(triangles[i][2]-0.1))
							
							x2 = $x_offset + Gosu::offset_x(120, $gridsize*triangles[i][3]) + Gosu::offset_x(60, $gridsize*triangles[i][4])
							y2 = $y_offset + Gosu::offset_y(120, $gridsize*triangles[i][3]) + Gosu::offset_y(60, $gridsize*triangles[i][4])
							xx2 = $x_offset + Gosu::offset_x(120, $gridsize*(triangles[i][3]+0.2)) + Gosu::offset_x(60, $gridsize*(triangles[i][4]-0.1))
							yy2 = $y_offset + Gosu::offset_y(120, $gridsize*(triangles[i][3]+0.2)) + Gosu::offset_y(60, $gridsize*(triangles[i][4]-0.1))
									
							x3 = $x_offset + Gosu::offset_x(120, $gridsize*triangles[i][5]) + Gosu::offset_x(60, $gridsize*triangles[i][6])
							y3 = $y_offset + Gosu::offset_y(120, $gridsize*triangles[i][5]) + Gosu::offset_y(60, $gridsize*triangles[i][6])
							xx3 = $x_offset + Gosu::offset_x(120, $gridsize*(triangles[i][5]-0.1)) + Gosu::offset_x(60, $gridsize*(triangles[i][6]+0.2))
							yy3 = $y_offset + Gosu::offset_y(120, $gridsize*(triangles[i][5]-0.1)) + Gosu::offset_y(60, $gridsize*(triangles[i][6]+0.2))
						else
							x1 = $x_offset + Gosu::offset_x(120, $gridsize*triangles[i][1]) + Gosu::offset_x(60, $gridsize*triangles[i][2])
							y1 = $y_offset + Gosu::offset_y(120, $gridsize*triangles[i][1]) + Gosu::offset_y(60, $gridsize*triangles[i][2])
							xx1 = $x_offset + Gosu::offset_x(120, $gridsize*(triangles[i][1]+0.1)) + Gosu::offset_x(60, $gridsize*(triangles[i][2]+0.1))
							yy1 = $y_offset + Gosu::offset_y(120, $gridsize*(triangles[i][1]+0.1)) + Gosu::offset_y(60, $gridsize*(triangles[i][2]+0.1))
									
							x2 = $x_offset + Gosu::offset_x(120, $gridsize*triangles[i][3]) + Gosu::offset_x(60, $gridsize*triangles[i][4])
							y2 = $y_offset + Gosu::offset_y(120, $gridsize*triangles[i][3]) + Gosu::offset_y(60, $gridsize*triangles[i][4])
							xx2 = $x_offset + Gosu::offset_x(120, $gridsize*(triangles[i][3]-0.2)) + Gosu::offset_x(60, $gridsize*(triangles[i][4]+0.1))
							yy2 = $y_offset + Gosu::offset_y(120, $gridsize*(triangles[i][3]-0.2)) + Gosu::offset_y(60, $gridsize*(triangles[i][4]+0.1))
									
							x3 = $x_offset + Gosu::offset_x(120, $gridsize*triangles[i][5]) + Gosu::offset_x(60, $gridsize*triangles[i][6])
							y3 = $y_offset + Gosu::offset_y(120, $gridsize*triangles[i][5]) + Gosu::offset_y(60, $gridsize*triangles[i][6])
							xx3 = $x_offset + Gosu::offset_x(120, $gridsize*(triangles[i][5]+0.1)) + Gosu::offset_x(60, $gridsize*(triangles[i][6]-0.2))
							yy3 = $y_offset + Gosu::offset_y(120, $gridsize*(triangles[i][5]+0.1)) + Gosu::offset_y(60, $gridsize*(triangles[i][6]-0.2))
						end
						
						self.draw_quad(x1, y1, c, x2, y2, c, x3, y3, c, x1, y1, c, 0)
						self.draw_quad(xx1, yy1, cc, xx2, yy2, cc, xx3, yy3, cc, xx1, yy1, cc, 0)
						
					end
				end
				
			end
			
		else
			
			@logo_img.draw_rot($window_width/2, 50, 1, 0, 0.5, 0.5, 1.0, 1.0, 0xff000000)
			
			## Ai only Button
			a = 20
			b = 150
			c = 120
			d = 180
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			if $ai_only == true
				color2 = 0xffffff00
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("Ai Only", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			## 1v1 Button
			a = $window_width/2-65
			b = 150
			c = $window_width/2+65
			d = 180
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("1v1 ai", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			## 1v1v1 Button
			a = $window_width/2-65
			b = 200
			c = $window_width/2+65
			d = 230
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("1v2 ai", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			## 1v1v1 big Button
			a = $window_width/2-65
			b = 250
			c = $window_width/2+65
			d = 280
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("1v2 ai big", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			## 1v1v1 bigger Button
			a = $window_width/2-65
			b = 300
			c = $window_width/2+65
			d = 330
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("1v2 ai bigger", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			## 6 player crowded
			a = $window_width/2-65
			b = 350
			c = $window_width/2+65
			d = 380
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("1v5 ai", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
			
			## 6 players bigger
			a = $window_width/2-65
			b = 400
			c = $window_width/2+65
			d = 430
			if point_in_rectangle(mouse_x, mouse_y, a, b, c, d)
				color1 = 0xff000000
				color2 = 0xffffff00
			else
				color1 = 0xff000000
				color2 = 0xffffffff
			end
			self.draw_quad(a, b, color1, c, b, color1, c, d, color1, a, d, color1, 11)
			self.draw_quad(a+3, b+3, color2, c-3, b+3, color2, c-3, d-3, color2, a+3, d-3, color2, 11)
			@bigfont.draw("1v5 ai bigger", a+9, b+6, 11, 1.0, 1.0, 0xff000000)
		end
		
	end
	
	def distance_to_goal(x, y, team)
		
		goalx = 0
		goaly = 0
		
		if $map == "2 players"
			
			if team == "red"
				goalx = 3
				goaly = 3
			elsif team == "blue"
				goalx = -3   ## -3
				goaly = -3   ## -3
			end
			
		elsif $map == "3 players"
			
			if team == "red"
				goalx = 3
				goaly = 3
			elsif team == "blue"
				goalx = -6
				goaly = 3
			elsif team == "green"
				goalx = 3
				goaly = -6
			end
			
		elsif $map == "3 players big"
			
			if team == "red"
				goalx = 4
				goaly = 4
				goals = [[4, 4], [3, 4], [4, 3], [3, 3], [2, 4], [4, 2], [2, 3], [3, 2], [1, 4], [4, 1]]
			elsif team == "blue"
				goalx = -8
				goaly = 4
				goals = [[-8, 4], [-7, 4], [-7, 3], [-6, 3], [-6, 4], [-6, 2], [-5, 3], [-5, 2], [-5, 4], [-5, 1]]
			elsif team == "green"
				goalx = 4
				goaly = -8
				goals = [[4, -8], [4, -7], [3, -7], [3, -6], [4, -6], [2, -6], [3, -5], [2, -5], [4, -5], [1, -5]]
			end
			
			for i in 0..goals.length-1
				if checker_exists_return(goals[i][0], goals[i][1]) == false
					goalx = goals[i][0]
					goaly = goals[i][1]
					break
				end
			end
			
		elsif $map == "3 players bigger"
			
			if team == "red"
				goalx = 5
				goaly = 5
				goals = [[5, 5], [5, 4], [4, 5], [4, 4], [5, 3], [3, 5], [4, 3], [3, 4], [5, 2], [2, 5], [3, 3], [2, 4], [4, 2], [1, 5], [5, 1]]
			elsif team == "blue"
				goalx = -10
				goaly = 5
				goals = [[-10, 5], [-9, 5], [-9, 4], [-8, 4], [-8, 5], [-8, 3], [-7, 4], [-7, 3], [-7, 5], [-7, 2], [-6, 3], [-6, 4], [-6, 2], [-6, 5], [-6, 1]]
			elsif team == "green"
				goalx = 5
				goaly = -10
				goals = [[5, -10], [5, -9], [4, -9], [4, -8], [5, -8], [3, -8], [4, -7], [3, -7], [5, -7], [2, -7], [3, -6], [4, -6], [2, -6], [5, -6], [1, -6]]
			end
			
			for i in 0..goals.length-1
				if checker_exists_return(goals[i][0], goals[i][1]) == false
					goalx = goals[i][0]
					goaly = goals[i][1]
					break
				end
			end
			
		elsif $map == "6 players"
			
			if team == "red"
				goalx = 3
				goaly = 3
			elsif team == "blue"
				goalx = -6
				goaly = 3
			elsif team == "green"
				goalx = 3
				goaly = -6
			elsif team == "orange"
				goalx = -3
				goaly = -3
			elsif team == "gray"
				goalx = 6
				goaly = -3
			elsif team == "magenta"
				goalx = -3
				goaly = 6
			end
		elsif $map == "6 players bigger"
			
			if team == "red"
				goalx = 5
				goaly = 5
				goals = [[5, 5], [5, 4], [4, 5], [4, 4], [5, 3], [3, 5], [4, 3], [3, 4], [5, 2], [2, 5], [3, 3], [2, 4], [4, 2], [1, 5], [5, 1]]
			elsif team == "blue"
				goalx = -10
				goaly = 5
				goals = [[-10, 5], [-9, 5], [-9, 4], [-8, 4], [-8, 5], [-8, 3], [-7, 4], [-7, 3], [-7, 5], [-7, 2], [-6, 3], [-6, 4], [-6, 2], [-6, 5], [-6, 1]]
			elsif team == "green"
				goalx = 5
				goaly = -10
				goals = [[5, -10], [5, -9], [4, -9], [4, -8], [5, -8], [3, -8], [4, -7], [3, -7], [5, -7], [2, -7], [3, -6], [4, -6], [2, -6], [5, -6], [1, -6]]
			elsif team == "orange"
				goalx = -5
				goaly = -5
				goals = [[-5, -5], [-5, -4], [-4, -5], [-4, -4], [-5, -3], [-3, -5], [-4, -3], [-3, -4], [-5, -2], [-2, -5], [-3, -3], [-2, -4], [-4, -2], [-1, -5], [-5, -1]]
			elsif team == "gray"
				goalx = 10
				goaly = -5
				goals = [[10, -5], [9, -5], [9, -4], [8, -4], [8, -5], [8, -3], [7, -4], [7, -3], [7, -5], [7, -2], [6, -3], [6, -4], [6, -2], [6, -5], [6, -1]]
			elsif team == "magenta"
				goalx = -5
				goaly = 10
				goals = [[-5, 10], [-5, 9], [-4, 9], [-4, 8], [-5, 8], [-3, 8], [-4, 7], [-3, 7], [-5, 7], [-2, 7], [-3, 6], [-4, 6], [-2, 6], [-5, 6], [-1, 6]]
			end
			
			for i in 0..goals.length-1
				if checker_exists_return(goals[i][0], goals[i][1]) == false
					goalx = goals[i][0]
					goaly = goals[i][1]
					break
				end
			end
			
		end
		
		real_goalx = $x_offset + Gosu::offset_x(120, $gridsize*goalx) + Gosu::offset_x(60, $gridsize*goaly)
		real_goaly = $y_offset + Gosu::offset_y(120, $gridsize*goalx) + Gosu::offset_y(60, $gridsize*goaly)
		
		real_x = $x_offset + Gosu::offset_x(120, $gridsize*x) + Gosu::offset_x(60, $gridsize*y)
		real_y = $y_offset + Gosu::offset_y(120, $gridsize*x) + Gosu::offset_y(60, $gridsize*y)
				
		dist = Gosu::distance(real_x, real_y, real_goalx, real_goaly)
		
		return dist
		
	end
	
	def calculate_total_distance(team)
		
		if $map == "2 players"
			
			if team == "red"
				goalx = 3
				goaly = 3
				goal_dists = 248
			elsif team == "blue"
				goalx = -3
				goaly = -3
				goal_dists = 248
			end
			
		elsif $map == "3 players"
			
			if team == "red"
				goalx = 3
				goaly = 3
				goal_dists = 248
			elsif team == "blue"
				goalx = -6
				goaly = 3
				goal_dists = 248
			elsif team == "green"
				goalx = 3
				goaly = -6
				goal_dists = 248
			end
		
		elsif $map == "3 players big"
			
			if team == "red"
				goalx = 4
				goaly = 4
				goal_dists = 533
			elsif team == "blue"
				goalx = -8
				goaly = 4
				goal_dists = 533
			elsif team == "green"
				goalx = 4
				goaly = -8
				goal_dists = 533
			end
			
		elsif $map == "3 players bigger"
			
			if team == "red"
				goalx = 5
				goaly = 5
				goal_dists = 1056
			elsif team == "blue"
				goalx = -10
				goaly = 5
				goal_dists = 1056
			elsif team == "green"
				goalx = 5
				goaly = -10
				goal_dists = 1056
			end
		elsif $map == "6 players"
			
			if team == "red"
				goalx = 3
				goaly = 3
				goal_dists = 248
			elsif team == "blue"
				goalx = -6
				goaly = 3
				goal_dists = 248
			elsif team == "green"
				goalx = 3
				goaly = -6
				goal_dists = 248
			elsif team == "orange"
				goalx = -3
				goaly = -3
				goal_dists = 248
			elsif team == "gray"
				goalx = 6
				goaly = -3
				goal_dists = 248
			elsif team == "magenta"
				goalx = -3
				goaly = 6
				goal_dists = 248
			end 
		
		elsif $map == "6 players bigger"
			
			if team == "red"
				goalx = 5
				goaly = 5
				goal_dists = 1056
			elsif team == "blue"
				goalx = -10
				goaly = 5
				goal_dists = 1056
			elsif team == "green"
				goalx = 5
				goaly = -10
				goal_dists = 1056
			elsif team == "orange"
				goalx = -5
				goaly = -5
				goal_dists = 1056
			elsif team == "gray"
				goalx = 10
				goaly = -5
				goal_dists = 1056
			elsif team == "magenta"
				goalx = -5
				goaly = 10
				goal_dists = 1056
			end
			
		end
		
		real_goalx = $x_offset + Gosu::offset_x(120, $gridsize*goalx) + Gosu::offset_x(60, $gridsize*goaly)
		real_goaly = $y_offset + Gosu::offset_y(120, $gridsize*goalx) + Gosu::offset_y(60, $gridsize*goaly)
		
		combined_dist = 0
		
		for i in 0..$checkers.length-1
			
			if $checkers[i].team == team
				
				x = $checkers[i].x
				y = $checkers[i].y
				
				crx = $x_offset + Gosu::offset_x(120, $gridsize*x) + Gosu::offset_x(60, $gridsize*y)
				cry = $y_offset + Gosu::offset_y(120, $gridsize*x) + Gosu::offset_y(60, $gridsize*y)
				
				combined_dist += Gosu::distance(real_goalx, real_goaly, crx, cry)
				
			end
		end
		
		puts "#{team}: #{combined_dist.round(2)}"
		
		case team
			when "red"
				$fit_red << combined_dist.round(2)
			when "blue"
				$fit_blue << combined_dist.round(2)
			when "green"
				$fit_green << combined_dist.round(2)
			when "orange"
				$fit_orange << combined_dist.round(2)
			when "gray"
				$fit_gray << combined_dist.round(2)
			when "magenta"
				$fit_magenta << combined_dist.round(2)
		end
		
		if combined_dist < goal_dists
			puts "#{team} reached the goal!"
			$teams.delete(team)
			
		end
		
	end
	
	def check_ai_turn(ai_team)
		
		best_moves_dist = []
		best_moves_coords = []
		checker_index = []
		
		for i in 0..$checkers.length-1
			if $checkers[i].team == ai_team and $checkers[i].ai_active == true
				
				cx = $checkers[i].x
				cy = $checkers[i].y
				ary = $checkers[i].get_viable_moves
				
				if ary.empty? == false  ## If you can move the checker
					
					dist_cur = distance_to_goal(cx, cy, ai_team)
					
					ddif = []
					
					for e in 0..ary.length-1
						
						ddist = distance_to_goal(ary[e][0], ary[e][1], ai_team)
						
						ddif << (dist_cur - ddist)*(dist_cur+1)   ### Higher is better. *dist_cur is an added weight making the further checkers more likely to be moved!
						
					end
					
					
					best_index = ddif.each_with_index.max[1]   ### For this checker, the best move is this
					
					best_moves_dist << ddif[best_index]    ### 1d array of distances
					best_moves_coords << [ary[best_index][0], ary[best_index][1]]   ### 2d array of coordinates for the best move
					checker_index << i
				else
					
					best_moves_dist << -100000
					best_moves_coords << [$checkers[i].x, $checkers[i].y]
					checker_index << i
					
				end
				
			end
		end
		
		if best_moves_dist.empty? == false
		
			best_checker = best_moves_dist.each_with_index.max[1]
			
			bestx = best_moves_coords[best_checker][0]
			besty = best_moves_coords[best_checker][1]
			
			$checkers[checker_index[best_checker]].jump(bestx, besty)
		else
			puts "wtf is going on lol"
			puts "ai_team: #{ai_team}"
			p best_moves_dist
			
		end
		
	end
	
	def checker_exists(x, y)
		for i in 0..$checkers.length-1
			if $checkers[i].x == x and $checkers[i].y == y
				return true
			end
		end
		return false
	end
	
	def checker_exists_return(x, y)
		for i in 0..$checkers.length-1
			if $checkers[i].x == x and $checkers[i].y == y and $checkers[i].team == $teams[0]
				return $checkers[i]
			end
		end
		return false
	end
	
	def tile_exists(x, y)
		for i in 0..$tiles.length-1
			if $tiles[i].x == x and $tiles[i].y == y
				return true
			end
		end
		return false
	end
	
	### Optimised point_in_rectangle. DOES NOT WORK IF SECOND POINT IS LESS THAN FIRST POINT!!!
	def point_in_rectangle(point_x, point_y, first_x, first_y, second_x, second_y)
		if point_x.between?(first_x, second_x) and point_y.between?(first_y, second_y)
			return true
		end
	end
	
	def needs_cursor?
		true
	end
	
end

class Checker
	
	attr_reader :x, :y, :team, :ai_active
	
	def initialize(window, x, y, team)
		
		@window, @x, @y, @team = window, x, y, team
		
		@selected = false
		
		@size = 24.0
		
		@jumps = []
		@jump_parents = []
		
		@animating = false
		
		@ai_active = true
	end
	
	def stop_animating
		@animating = false
	end
	
	def jump(x, y)
		
		if @jumps.empty? == false
			
			### Animation steps
			cx = x
			cy = y
			$moves = []
			while true
				indx = @jumps.index([cx, cy])
				par_indx = @jump_parents[indx]
				$moves << [@jumps[indx][0], @jumps[indx][1]]
				if par_indx == false
					$moves << [@x, @y]
					break
				end
				cx = @jumps[par_indx][0]
				cy = @jumps[par_indx][1]
			end
			$moves.reverse!
			
			$animating_inst = self
			@animating = true
			$animating = true
			
			### Animation over
			
			## Move
			@x = x
			@y = y
			
			## Check if ai
			if $ais.include?($teams[0])
				
				## If you're landing on the current farthest goal
				self.check_if_active
				
			end
			
			team_cur = $teams[0]
			
			## Check if you won
			@window.calculate_total_distance(team_cur)
			
			## Switch to next team
			if $teams.include?(team_cur)
				$teams.rotate!
			end
			$team_turn = $teams[0]
		else
			
			puts "#{$teams[0]} can't move anything and passes the turn!"
			
			team_cur = $teams[0]
			
			## Check if you won
			@window.calculate_total_distance(team_cur)
			
			## Switch to next team
			if $teams.include?(team_cur)
				$teams.rotate!
			end
			$team_turn = $teams[0]
			
			
			# $animating_inst.stop_animating
			$checkers.each { |inst|  inst.stop_animating }
			$animating = false
			$animation_speed = $animation_speed_max
			
			## Run ai turn if there are any
			if $ais.empty? == false
				for i in 0..$ais.length-1
					if $team_turn == $ais[i]
						@window.check_ai_turn($ais[i])
						break
					end
				end
			end
			
		end
	end
	
	def deactivate
		if @ai_active == true
			@ai_active = false
		end
	end
	
	def check_if_active
		if $map == "3 players big"
			if $teams[0] == "red"
				goals = [[4, 4], [3, 4], [4, 3], [3, 3], [2, 4], [4, 2], [2, 3], [3, 2], [1, 4], [4, 1]]
			elsif $teams[0] == "blue"
				goals = [[-8, 4], [-7, 4], [-7, 3], [-6, 3], [-6, 4], [-6, 2], [-5, 3], [-5, 2], [-5, 4], [-5, 1]]
			elsif $teams[0] == "green"
				goals = [[4, -8], [4, -7], [3, -7], [3, -6], [4, -6], [2, -6], [3, -5], [2, -5], [4, -5], [1, -5]]
			end
		elsif $map == "3 players bigger"
			if $teams[0] == "red"
				goals = [[5, 5], [5, 4], [4, 5], [4, 4], [5, 3], [3, 5], [4, 3], [3, 4], [5, 2], [2, 5], [3, 3], [2, 4], [4, 2], [1, 5], [5, 1]]
			elsif $teams[0] == "blue"
				goals = [[-10, 5], [-9, 5], [-9, 4], [-8, 4], [-8, 5], [-8, 3], [-7, 4], [-7, 3], [-7, 5], [-7, 2], [-6, 3], [-6, 4], [-6, 2], [-6, 5], [-6, 1]]
			elsif $teams[0] == "green"
				goals = [[5, -10], [5, -9], [4, -9], [4, -8], [5, -8], [3, -8], [4, -7], [3, -7], [5, -7], [2, -7], [3, -6], [4, -6], [2, -6], [5, -6], [1, -6]]
			end
		elsif $map == "6 players bigger"
			if $teams[0] == "red"
				goals = [[5, 5], [5, 4], [4, 5], [4, 4], [5, 3], [3, 5], [4, 3], [3, 4], [5, 2], [2, 5], [3, 3], [2, 4], [4, 2], [1, 5], [5, 1]]
			elsif $teams[0] == "blue"
				goals = [[-10, 5], [-9, 5], [-9, 4], [-8, 4], [-8, 5], [-8, 3], [-7, 4], [-7, 3], [-7, 5], [-7, 2], [-6, 3], [-6, 4], [-6, 2], [-6, 5], [-6, 1]]
			elsif $teams[0] == "green"
				goals = [[5, -10], [5, -9], [4, -9], [4, -8], [5, -8], [3, -8], [4, -7], [3, -7], [5, -7], [2, -7], [3, -6], [4, -6], [2, -6], [5, -6], [1, -6]]
			elsif $teams[0] == "orange"
				goals = [[-5, -5], [-5, -4], [-4, -5], [-4, -4], [-5, -3], [-3, -5], [-4, -3], [-3, -4], [-5, -2], [-2, -5], [-3, -3], [-2, -4], [-4, -2], [-1, -5], [-5, -1]]
			elsif $teams[0] == "gray"
				goals = [[10, -5], [9, -5], [9, -4], [8, -4], [8, -5], [8, -3], [7, -4], [7, -3], [7, -5], [7, -2], [6, -3], [6, -4], [6, -2], [6, -5], [6, -1]]
			elsif $teams[0] == "magenta"
				goals = [[-5, 10], [-5, 9], [-4, 9], [-4, 8], [-5, 8], [-3, 8], [-4, 7], [-3, 7], [-5, 7], [-2, 7], [-3, 6], [-4, 6], [-2, 6], [-5, 6], [-1, 6]]
			end
			
		end
		
		if goals != nil
			for i in 0..goals.length-1
				inst = @window.checker_exists_return(goals[i][0], goals[i][1])
				if inst == false
					break
				else
					if inst.ai_active == true
						inst.deactivate
					end
				end
			end
		end
	end
	
	def check_mouse_pressed(mx, my)
		
		$selection = false
		@selected = false
		
		for i in 0..@jumps.length-1
				
			xx = @jumps[i][0]
			yy = @jumps[i][1]
			
			rx = $x_offset + Gosu::offset_x(120, $gridsize*xx) + Gosu::offset_x(60, $gridsize*yy)
			ry = $y_offset + Gosu::offset_y(120, $gridsize*xx) + Gosu::offset_y(60, $gridsize*yy)
			
			if Gosu::distance(mx, my, rx, ry) < @size/2
				
				self.jump(xx, yy)
				
				break
				
			end
			
		end
		
	end
	
	def check_selected(mx, my)
		@selected = false
		
		if $team_turn == @team
			rx = $x_offset + Gosu::offset_x(120, $gridsize*@x) + Gosu::offset_x(60, $gridsize*@y)
			ry = $y_offset + Gosu::offset_y(120, $gridsize*@x) + Gosu::offset_y(60, $gridsize*@y)
			
			if Gosu::distance(mx, my, rx, ry) < @size/2
				@selected = true
				$selection = self
				self.get_viable_moves
			end
		end
	end
	
	def get_viable_jumps(jx, jy, parent)
		
		#####           up       down   l-down   l-up    r-up     r-down 
		directions = [[-1, 1], [1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]]
		
		for i in 0..directions.length-1
			
			xx = jx + directions[i][0]
			yy = jy + directions[i][1]
			
			if @window.tile_exists(xx, yy)
				if @window.checker_exists(xx, yy) == true
					xx2 = jx + directions[i][0]*2
					yy2 = jy + directions[i][1]*2
					if @window.tile_exists(xx2, yy2)
						if @window.checker_exists(xx2, yy2) == false and @jumps.include?([xx2, yy2]) == false
							@jumps << [xx2, yy2]
							@jump_parents << parent
							self.get_viable_jumps(xx2, yy2, @jumps.length-1)
						end
					end
				end
			end
		end
		
	end
	
	def get_viable_moves
		@jumps = []   #### [x, y] 
		@jump_parents = [] #### [index, index, index, ...]
		
		long_jumps = []
		
		#####           up       down   l-down   l-up    r-up     r-down 
		directions = [[-1, 1], [1, -1], [1, 0], [0, 1], [-1, 0], [0, -1]]
		
		for i in 0..directions.length-1
			
			xx = @x + directions[i][0]
			yy = @y + directions[i][1]
			
			if @window.tile_exists(xx, yy)
				if @window.checker_exists(xx, yy) == false
					@jumps << [xx, yy]
					@jump_parents << false
				else
					xx2 = @x + directions[i][0]*2
					yy2 = @y + directions[i][1]*2
					if @window.tile_exists(xx2, yy2)
						if @window.checker_exists(xx2, yy2) == false and @jumps.include?([xx2, yy2]) == false
							@jumps << [xx2, yy2]
							@jump_parents << false
							long_jumps << [xx2, yy2, @jumps.length-1]
						end
					end
				end
			end
			
		end
		
		if long_jumps.empty? == false
			for i in 0..long_jumps.length-1
				self.get_viable_jumps(long_jumps[i][0], long_jumps[i][1], long_jumps[i][2])
			end
		end
		
		return @jumps
		
	end
	
	def update
		## Placeholder
	end
	
	def draw
		
		if @selected == true
			col = 0xffffaa00
			
			for i in 0..@jumps.length-1
				
				xx = @jumps[i][0]
				yy = @jumps[i][1]
				
				rx = $x_offset + Gosu::offset_x(120, $gridsize*xx) + Gosu::offset_x(60, $gridsize*yy)
				ry = $y_offset + Gosu::offset_y(120, $gridsize*xx) + Gosu::offset_y(60, $gridsize*yy)
				
				@window.circle_img.draw_rot(rx, ry, 1, 0, 0.5, 0.5, 12.0/100, 12.0/100, 0xff333333)
				
			end
			
		else
			if @team == "red"
				col = 0xffff0000
			elsif @team == "blue"
				col = 0xff0000ff
			elsif @team == "green"
				col = 0xff00cc00
			elsif @team == "orange"
				col = 0xffffcc00
			elsif @team == "gray"
				col = 0xff888888
			elsif @team == "magenta"
				col = 0xffff00ff
			end
		end
		
		if @ai_active == false and $show_targets == true
			col = 0xff000000
		end
		
		if @animating == false
			
			rx = $x_offset + Gosu::offset_x(120, $gridsize*@x) + Gosu::offset_x(60, $gridsize*@y)
			ry = $y_offset + Gosu::offset_y(120, $gridsize*@x) + Gosu::offset_y(60, $gridsize*@y)
			
			@window.circle_img.draw_rot(rx, ry, 1, 0, 0.5, 0.5, @size/100, @size/100, col)
			
		else
			
			x1 = $moves[0][0]
			y1 = $moves[0][1]
			
			x2 = $moves[1][0]
			y2 = $moves[1][1]
			
			rx1 = $x_offset + Gosu::offset_x(120, $gridsize*x1) + Gosu::offset_x(60, $gridsize*y1)
			ry1 = $y_offset + Gosu::offset_y(120, $gridsize*x1) + Gosu::offset_y(60, $gridsize*y1)
			
			rx2 = $x_offset + Gosu::offset_x(120, $gridsize*x2) + Gosu::offset_x(60, $gridsize*y2)
			ry2 = $y_offset + Gosu::offset_y(120, $gridsize*x2) + Gosu::offset_y(60, $gridsize*y2)
			
			cx = rx1 + (rx2-rx1)*($animation_speed_max - $animation_speed)*1.0/$animation_speed_max
			cy = ry1 + (ry2-ry1)*($animation_speed_max - $animation_speed)*1.0/$animation_speed_max
			
			@window.circle_img.draw_rot(cx, cy, 1, 0, 0.5, 0.5, @size/100, @size/100, col)
			
		end
		
	end
	
end

class Tile
	
	attr_reader :x, :y
	
	def initialize(window, x, y, color)
		@window, @x, @y, @color = window, x, y, color
	end
	
	def update
		
	end
	
	def draw
		cx = $x_offset + Gosu::offset_x(120, $gridsize*@x) + Gosu::offset_x(60, $gridsize*@y)
		cy = $y_offset + Gosu::offset_y(120, $gridsize*@x) + Gosu::offset_y(60, $gridsize*@y)
		@window.point_img.draw_rot(cx, cy, 1, 0, 0.5, 0.5, 80.0/100, 80.0/100, @color)
		
		mx = @window.mouse_x
		my = @window.mouse_y
		
		if Gosu::distance(cx, cy, mx, my) < 7
			@window.font.draw("[#{@x}, #{@y}]", cx, cy-10, 12, 1.0, 1.0, 0xff000000)
		end
		
	end
	
end

# show the window
window = GameWindow.new
window.show