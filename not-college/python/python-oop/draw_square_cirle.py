#!/usr/bin/python2.7

import turtle

def draw_circle_square():
	window = turtle.Screen()
	window.bgcolor('#000')
	sprite = turtle.Turtle(shape='turtle')
	sprite.color('yellow')
	
	for i in range(1,(360/10)*4 + 1):
		sprite.forward(100)
		sprite.right(90)
		sprite.speed(10)
		if i% 4 == 0:
			sprite.right(10)
	window.bgcolor('#cbc')
	
	turtle.write("Hello world!", move=True, align="Left", font=("Arial", 20))
	window.exitonclick()
	
draw_circle_square()








