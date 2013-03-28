note
	description: "Summary description for {GAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Unnamed", "protocol=URI", "src=http://www.yourwebsite.com"

class
	GAME
inherit
	ARGUMENTS
create
	make
feature -- Access

--	BACKGROUND: IMAGE
--			 `BACKGROUND'
--		attribute Result := ({like BACKGROUND}).default end --| Remove line when Void Safety is properly set

	make
		local
			l_memory_manager, l_target_area, l_bmp, l_window, l_event:POINTER
			l_image_nom:STRING
			l_c_string_bmp:C_STRING
			l_blit_surface, l_flip:INTEGER
			l_quit, l_event_type:NATURAL_8
			l_img:IMAGE
			l_mur:MUR
			l_barre, l_barre2:BARRE
			l_deplacement:DEPLACEMENT
			l_balle:BALLE
			l_pointage: POINTAGE
		do
			--| Add your code here
			if
				{SDL_WRAPPER}.SDL_Init({SDL_WRAPPER}.SDL_INIT_VIDEO)<0
			then
				print ("Initialisation de l'initialisation � �chou�!%N")
			end
			create l_memory_manager.default_create
			create l_img
			create l_pointage.creer_pointage
			create l_mur.creer_mur
			create l_barre.creer_barre(10, 300)
			create l_barre2.creer_barre(1250, 300)
			create l_balle.creer_balle(30, 450)
			create l_deplacement
			l_image_nom := l_img.background
			create l_c_string_bmp.make (l_image_nom)
			l_target_area := l_memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Rect)
			l_bmp := {SDL_WRAPPER}.SDL_LoadBMP(l_c_string_bmp.item)
			l_window := {SDL_WRAPPER}.SDL_SetVideoMode({SDL_WRAPPER}.get_bmp_w(l_bmp), {SDL_WRAPPER}.get_bmp_h(l_bmp),32, {SDL_WRAPPER}.SDL_SWSURFACE)

			{SDL_WRAPPER}.set_SDL_target_area_H(l_target_area, {SDL_WRAPPER}.get_bmp_h(l_bmp))
			{SDL_WRAPPER}.set_SDL_target_area_W(l_target_area, {SDL_WRAPPER}.get_bmp_w(l_bmp))
			{SDL_WRAPPER}.set_SDL_target_area_X(l_target_area, 0)
			{SDL_WRAPPER}.set_SDL_target_area_Y(l_target_area, 0)


			l_event := l_memory_manager.memory_alloc({SDL_WRAPPER}.sizeof_SDL_Event)

			from
				l_event_type := {SDL_WRAPPER}.get_SDL_EventType(l_event)
				l_quit := {SDL_WRAPPER}.SDL_QUIT
			until
				l_quit=l_event_type
			loop

				if
					{SDL_WRAPPER}.SDL_PollEvent(l_event)<1
				then
				end
				l_event_type := {SDL_WRAPPER}.get_SDL_EventType(l_event)

				if
					l_event_type = {SDL_WRAPPER}.SDL_KEYDOWN
				then
					l_deplacement.bouton_presse(l_event, l_barre, 72, 80)
					l_deplacement.bouton_presse(l_event, l_barre2, 16, 30)
				end

				l_blit_surface := {SDL_WRAPPER}.SDL_BlitSurface(l_bmp, create {POINTER}, l_window, l_target_area)
				l_mur.mur_haut(l_window)
				l_mur.mur_bas(l_window)
				l_barre.player1_afficher(l_window)
				l_barre2.player1_afficher(l_window)
				l_balle.afficher_balle (l_window)
				--l_deplacement.balle_deplacement(l_balle, l_barre, l_barre2)


				l_flip := {SDL_WRAPPER}.SDL_Flip(l_window)

				{SDL_WRAPPER}.SDL_Delay(10)
			end

			if
				{SDL_WRAPPER}.SDL_QuitEvent(l_window)<2
			then
			end

			l_target_area.memory_free
		end

end
