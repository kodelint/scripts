��< #  
 . N a m e     :   D e p l o y - V M . p s 1  
 . A u t h o r :   S a t y a j i t   R o y   C h o u d h u r y  
 . D a t e     :   2 7 . 0 6 . 2 0 1 3  
 . U s a g e   :   S c r i p t   w i l l   d e p l o y   V M s   f r o m   a   c s v   f i l e   l i s t .  
 # >  
  
 $ V M D a t a s t o r e   =   " D A T A S t o r e "  
 $ V M L o c a t i o n   =   " P u p p e t "  
 $ V M D e p l o y T e m p l a t e   =   " C e n t O S 6 . 4 _ T M P L _ P r o d "  
 $ v m H o s t   =   " e s x i . e x a m p l e . c o m "  
 $ n e t m a s k 1   =   " 2 5 5 . 2 5 5 . 2 5 2 . 0 "  
 $ e t h 0   =   " e t h 0 "  
 $ e t h 1   =   " e t h 1 "  
 $ e t h 2   =   " e t h 2 "  
 $ e t h 3   =   " e t h 3 "  
 $ g a t e w a y   =   " 1 0 . 1 0 . 1 0 . 1 0 "  
  
 # C o n n e c t   t o   v C e n t e r  
 C o n n e c t - V I s e r v e r   v C e n t e r . e x a m p l e . c o m  
  
 I m p o r t - C s v   C : \ t m p \ t e s t v m . c s v   |  
  
 F o r e a c h   {  
 	 W r i t e - H o s t   " C r e a t i n g   V M   " $ _ . V M N a m e  
 	 N e w - V M   - N a m e   $ _ . V M N a m e   - V M H o s t   $ v m H o s t   - T e m p l a t e   $ V M D e p l o y T e m p l a t e   - D a t a s t o r e   $ V M D a t a s t o r e   - L o c a t i o n   $ V M L o c a t i o n  
 	 	 	  
 	 W r i t e - H o s t   " N o w   s t a r t i n g   V M   " $ _ . V M N a m e  
                  
         S t a r t - V M   - V M   $ _ . V M N a m e  
 	  
 	 W r i t e - H o s t   " S T A R T i n g   V L A N   c o n f i g u r a t i o n . . . . . . "  
 	  
 	 s l e e p   - S e c o n d s   6 0  
 	  
 	 W r i t e - h o s t   " W a i t i n g   F o r   V M   C o n f i g u r a t i o n   T o   U p d a t e   W i t h i n   V C "  
 	  
 	 s l e e p   - S e c o n d s   6 0  
 	  
 	 #   I d e n t i f y   t h e   r i g h t   I n t e r f a c e  
 	 $ e t h e r n e t 0   =   G e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M   $ _ . V M N a m e   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   |   w h e r e - o b j e c t   {   $ _ . N a m e   - e q   " e t h 0 " }  
 	 $ e t h e r n e t 1   =   G e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M   $ _ . V M N a m e   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   |   w h e r e - o b j e c t   {   $ _ . N a m e   - e q   " e t h 1 " }  
 	 $ e t h e r n e t 2   =   G e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M   $ _ . V M N a m e   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   |   w h e r e - o b j e c t   {   $ _ . N a m e   - e q   " e t h 2 " }  
 	 $ e t h e r n e t 3   =   G e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M   $ _ . V M N a m e   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   |   w h e r e - o b j e c t   {   $ _ . N a m e   - e q   " e t h 3 " }  
 	  
 	 R e m o v e - N e t w o r k A d a p t e r   - N e t w o r k A d a p t e r   $ e t h e r n e t 2   - C o n f i r m : $ f a l s e  
 	 R e m o v e - N e t w o r k A d a p t e r   - N e t w o r k A d a p t e r   $ e t h e r n e t 3   - C o n f i r m : $ f a l s e  
 	  
 	 S e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M G u e s t N e t w o r k I n t e r f a c e   $ e t h e r n e t 0   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   - I P   $ _ . e t h 0   - N e t m a s k   $ n e t m a s k 1  
 	 S e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M G u e s t N e t w o r k I n t e r f a c e   $ e t h e r n e t 1   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   - I P   $ _ . e t h 1   - N e t m a s k   $ n e t m a s k 1   - G a t e w a y   $ g a t e w a y  
 	 # S e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M G u e s t N e t w o r k I n t e r f a c e   $ e t h e r n e t 2   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   - I P   $ _ . e t h 2   - N e t m a s k   $ n e t m a s k 1  
 	 # S e t - V M G u e s t N e t w o r k I n t e r f a c e   - V M G u e s t N e t w o r k I n t e r f a c e   $ e t h e r n e t 3   - H o s t U s e r   r o o t   - H o s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - G u e s t P a s s w o r d   P a s s w o r d   - I P   $ _ . e t h 3   - N e t m a s k   $ n e t m a s k 1  
 	  
 	 $ h o s t n a m e   =   ' e c h o   '   +   ' " '   +   ' H O S T N A M E = '   +   $ _ . V M N a m e   +   ' " '   +   '   > >   / e t c / s y s c o n f i g / n e t w o r k '  
 	  
 	 #   I n v o k i n g   l o c a l   s c r i p t s   t o   c o m p l e t e   t h e   d e p l o y m e n t s  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   $ h o s t n a m e   - G u e s t P a s s w o r d   P a s s w o r d   - G u e s t U s e r   r o o t   - V M   $ _ . V M N a m e  
         #   S t o p   i n c r e a s i n g   t h e   E t h   n u m b e r s  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   " r m   - r f   / e t c / u d e v / r u l e s . d / 7 0 - p e r s i s t e n t - n e t . r u l e s "   - G u e s t P a s s w o r d   P a s s w o r d   - G u e s t U s e r   r o o t   - V M   $ _ . V M N a m e  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   " r m   - r f   / e t c / s y s c o n f i g / n e t w o r k - s c r i p t s / r o u t e - e t h * "   - G u e s t P a s s w o r d   P a s s w o r d   - G u e s t U s e r   r o o t   - V M   $ _ . V M N a m e  
         #   R e m o v e   t h e   l i b r a r y  
         I n v o k e - V M S c r i p t   - S c r i p t T e x t   " r m   - r f   / u s r / l i b / v m w a r e - t o o l s / p l u g i n s 3 2 / v m s v c / l i b t i m e S y n c . s o "   - G u e s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - V M   $ _ . V M N a m e  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   " r m   - r f   / u s r / l i b / v m w a r e - t o o l s / p l u g i n s 6 4 / v m s v c / l i b t i m e S y n c . s o "   - G u e s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - V M   $ _ . V M N a m e  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   " / b i n / s e d   - i   - e   ' s / 1 0 2 4 / u n l i m i t e d / '   / e t c / s e c u r i t y / l i m i t s . d / 9 0 - n p r o c . c o n f "   - G u e s t P a s s w o r d   Password  - G u e s t U s e r   r o o t   - V M   $ _ . V M N a m e  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   " / s b i n / r o u t e   a d d   - n e t   d e f a u l t   g w   X . X . X . X "   - V M   $ _ . V M N a m e   - G u e s t P a s s w o r d   P a s s w o r d   - G u e s t U s e r   r o o t   - R u n A s y n c  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   " / s b i n / s e r v i c e   n e t w o r k   r e s t a r t "   - V M   $ _ . V M N a m e   - G u e s t P a s s w o r d   P a s s w o r d   - G u e s t U s e r   r o o t   - R u n A s y n c  
 	 I n v o k e - V M S c r i p t   - S c r i p t T e x t   " / s b i n / r e b o o t "   - V M   $ _ . V M N a m e   - G u e s t P a s s w o r d   P a s s w o r d   - G u e s t U s e r   r o o t   - R u n A s y n c  
 	  
 	 } 
