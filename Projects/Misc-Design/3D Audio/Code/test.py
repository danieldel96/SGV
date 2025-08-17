# import the pygame module, so you can use it
import pygame
import cv2
import shutil
import os
import sys
import time
import math

#return in between (inb = 10) points between two points
def track(start, finish, inb = 10):
    print(start,finish)
    x1 = start[0]
    x2 = finish[0]
    y1 = start[1]
    y2 = finish[1]
    if( x2 == x1):
        m = 0
    else:
        m = (y2-y1)/(x2-x1)

    points = []
    steps = (x2-x1)/inb
    x = x1
    for i in range(inb):
        x = steps + x
        y = m*(x - x1) + y1
        points.append((x,y))
    return points


def main():

    #right right map coordinates
    r_r = [(300,500),(275,460),(317,412),(343,357),(375,325),(380,265),(345,223),(325,170),(290,140), (280,80)]
    #middle right coordinates
    m_r = [(300,500),(275,460),(317,412),(343,357),(320,315),(325,250),(345,223),(325,170),(290,140), (280,80)]
    #middle left coordinates
    m_l = [(300,500),(275,460),(235,445),(220,400),(253,373),(235,300),(220,275),(240,190),(290,140), (280,80)]
    #left left coordinates
    l_l = [(300,500),(275,460),(235,445),(220,400),(180,370),(175,303),(220,275),(240,190),(290,140), (280,80)]
    # initialize the pygame module
    pygame.init()

    # load and set the logo
    logo = pygame.image.load("mandel.png")
    pygame.display.set_icon(logo)
    pygame.display.set_caption("minimal program")
     
    # create a surface on screen that has the size of 240 x 180
    screen_width = 600
    screen_height = 600
    screen = pygame.display.set_mode((screen_width,screen_height))
    
    bgd = cv2.imread('bgd.jpg')
    bgd = cv2.resize(bgd,(screen_width,screen_height))
    cv2.imwrite('foo.png', bgd)
    bgd = pygame.image.load('foo.png')
    screen.blit(bgd, (0,0))

    pin = cv2.imread('walking.png')
    pin = cv2.resize(pin,(10,10))
    cv2.imwrite('foo.png', pin)
    pin = pygame.image.load('foo.png')
    screen.blit(pin, (50,50))
    
    pygame.display.flip()

    #********************* button initializing
    color = (255,255,255)
  
    # light shade of the button
    color_light = (170,170,170)
  
    # dark shade of the button
    color_dark = (100,100,100)

    smallfont = pygame.font.SysFont('Corbel',35)

    text = smallfont.render('quit' , True , color)

    width = screen.get_width()
  
    height = screen.get_height()

    half_height = height/2
    half_width = width/2

    #logic_mouse_l_l = 
    #*********************


    #********************************** map position initializing
    # define a variable to control the main loop
    running = True
    position = 1 #first segment

    length_of_segment = 60 #seconds to complete each segment (dot to dot)
 
    last_position = 0 #0 segment
    initial = time.time()
    jump = False
    play = True
    

    walking_position = 1
    walking_points = 100
    walking_initial = time.time()

    current_array = r_r

    points = points = track(current_array[position],current_array[last_position],walking_points)

    track_num = 0
    #*************************************

    # main loop
    while running:
         # event handling, gets all event from the event queue
        for event in pygame.event.get():
            # only do something if the event is of type QUIT
            if event.type == pygame.QUIT:
                # change the value to False, to exit the main loop
                running = False

            if event.type == pygame.MOUSEBUTTONDOWN:
              
            #if the mouse is clicked on the
            # button the game is terminated
                if half_width <= mouse[0] <= half_width+250 and half_height <= mouse[1] <= half_height+45:
                    current_array = l_l
                    # define a variable to control the main loop
                    running = True
                    position = 1 #first segment
                    last_position = 0 #0 segment
                    initial = time.time()
                    jump = False
                    play = True
                    walking_position = 1
                    walking_points = 100
                    walking_initial = time.time()
                    points = points = track(current_array[position],current_array[last_position],walking_points)
                    track_num = 0

                if half_width <= mouse[0] <= half_width+250 and half_height+45<= mouse[1] <= half_height+90: 
                    current_array = r_r
                    # define a variable to control the main loop
                    running = True
                    position = 1 #first segment
                    last_position = 0 #0 segment
                    initial = time.time()
                    jump = False
                    play = True
                    walking_position = 1
                    walking_points = 100
                    walking_initial = time.time()
                    points = points = track(current_array[position],current_array[last_position],walking_points)
                    track_num = 1
        
                if half_width <= mouse[0] <= half_width+250 and half_height+90 <= mouse[1] <= half_height+135: 
                    current_array = m_r
                    # define a variable to control the main loop
                    running = True
                    position = 1 #first segment
                    last_position = 0 #0 segment
                    initial = time.time()
                    jump = False
                    play = True
                    walking_position = 1
                    walking_points = 100
                    walking_initial = time.time()
                    points = points = track(current_array[position],current_array[last_position],walking_points)
                    track_num = 2

                if half_width <= mouse[0] <= half_width+250 and half_height+135 <= mouse[1] <= half_height+180: 
                    current_array = m_l
                    # define a variable to control the main loop
                    running = True
                    position = 1 #first segment
                    last_position = 0 #0 segment
                    initial = time.time()
                    jump = False
                    play = True
                    walking_position = 1
                    walking_points = 100
                    walking_initial = time.time()
                    points = points = track(current_array[position],current_array[last_position],walking_points)
                    track_num = 3


        #***********position stuff
        current = time.time()
        walking_current = time.time()

        if( (current - initial) > length_of_segment):
            jump = True

        if( jump ):
            position += 1
            walking_position = 0
            last_position += 1
            initial = time.time()

        if(last_position > len(current_array) - 1): #reset position
            last_position = 0

        if(position > len(current_array) - 1): #reset last position
            position = 0
            play = True
        
        #array of in between points [1, 2, ... ,9 , 10]
        if( jump ):    
            points = track(current_array[position],current_array[last_position],walking_points)
            jump = False

        if( (walking_current - walking_initial) > length_of_segment/walking_points):
            walking_initial = time.time()
            walking_position += 1


        if( position == 1 and play and track_num == 0):
            pygame.mixer.music.load('l_l.wav')
            pygame.mixer.music.play(-1)
            play = False

        if( position == 1 and play and track_num == 1):
            pygame.mixer.music.load('r_r.wav')
            pygame.mixer.music.play(-1)
            play = False

        if( position == 1 and play and track_num == 2):
            pygame.mixer.music.load('m_r.wav')
            pygame.mixer.music.play(-1)
            play = False

        if( position == 1 and play and track_num == 3):
            pygame.mixer.music.load('m_l.wav')
            pygame.mixer.music.play(-1)
            play = False

        screen.blit(text , (half_width+50,half_height))
        screen.blit(bgd, (0,0))

        if(walking_position == walking_points):
            walking_position = walking_position - 1

        
        screen.blit(pin, points[walking_points - walking_position - 1])
        #**************
 
        #************ button stuff
        mouse = pygame.mouse.get_pos()

        pygame.draw.rect(screen,color_light,[half_width + 100,half_height,180,40]) #l_l
        screen.blit(smallfont.render('Left Left' , True , color), (half_width +100,half_height))

        pygame.draw.rect(screen,color_light,[half_width+100,half_height +45,180,40]) #r_r
        screen.blit(smallfont.render('Right Right' , True , color), (half_width+100,half_height+ 45))

        pygame.draw.rect(screen,color_light,[half_width+100,half_height +90,180,40]) #r_r
        screen.blit(smallfont.render('Middle Right' , True , color), (half_width+100,half_height+ 90))

        pygame.draw.rect(screen,color_light,[half_width+100,half_height +135,180,40]) #r_r
        screen.blit(smallfont.render('Middle Left' , True , color), (half_width+100,half_height+ 135))

    
       


        #************

        #update game    
        pygame.display.update()

     
# run the main function only if this module is executed as the main script
# (if you import this as a module then nothing is executed)
if __name__=="__main__":
    # call the main function
    main()