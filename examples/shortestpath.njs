sp mpq_push

end

sp mpq_pop

end

sp dijkstra
	this >> dst src;
	numEdges << #this;
	MPQ_node << 0 src;
	MPQ << &MPQ_node;
	Path << src;
	X << &MPQ &Path &this dijkstra_aux; *X;	
	%TODO: put the result in *this* somehow	
end

sp main
	%% make a graph
	Edge1 << "1" "2" 7;
	Edge2 << "1" "3" 9;
	Edge3 << "1" "6" 14;
	Edge4 << "2" "3" 10;
	Edge5 << "2" "4" 15;
	Edge6 << "3" "4" 11;
	Edge7 << "3" "6" 2;
	Edge8 << "4" "5" 6;
	Edge9 << "5" "6" 9;
	G << Edge1 Edge2 Edge3 Edge4 Edge5 Edge6 Edge7 Edge8 Edge9;
	%%find the shortest path between "1" and "5"
	G << "1" "5" dijkstra; *G;
	G << print; *G;
	X << "" println_pop; *X;	
end
