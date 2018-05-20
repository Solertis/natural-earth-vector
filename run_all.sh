#!/bin/bash
set -Eeuo pipefail


STARTDATE=$(date +"%Y-%m-%dT%H:%M%z")

# clean and recreate x_tempshape directory
rm   -rf x_tempshape
mkdir -p x_tempshape
log_file=x_tempshape/run_all.log
#####  backup log from here ...
exec &> >(tee -a "$log_file")

# Don't forget update the VERSION file!
cat VERSION

# Show some debug info
python3 ./tools/wikidata/platform_debug_info.py


# Summary Log file
logmd=x_tempshape/update.md
rm -f $logmd

# --------------------------------------------------------------------------------------------------------------------
#  mode =  fetch | write | fetch_write | copy | all
#  LetterCase = uppercase  --> variable names [WIKIDATAID, NAME_AR, NAME_BN, NAME_DE, NAME_EN, NAME_ES, ... ]
#  LetterCase = lowercase  --> variable names [wikidataid, name_ar, name_bn, name_de, name_en, name_es, ... ]
# --------------------------------------------------------------------------------------------------------------------
#                          |mode |LetterCase| shape_path  |  shape filename
# == 10m ================= |==== |==========| ============| ================================================
./tools/wikidata/update.sh  all   uppercase   10m_cultural  ne_10m_admin_0_countries_lakes
./tools/wikidata/update.sh  all   uppercase   10m_cultural  ne_10m_admin_0_countries
./tools/wikidata/update.sh  all   uppercase   10m_cultural  ne_10m_admin_0_disputed_areas
./tools/wikidata/update.sh  all   uppercase   10m_cultural  ne_10m_admin_0_map_subunits
./tools/wikidata/update.sh  all   uppercase   10m_cultural  ne_10m_admin_0_map_units
./tools/wikidata/update.sh  all   uppercase   10m_cultural  ne_10m_admin_0_sovereignty
./tools/wikidata/update.sh  all   lowercase   10m_cultural  ne_10m_admin_1_states_provinces_lakes
./tools/wikidata/update.sh  all   lowercase   10m_cultural  ne_10m_admin_1_states_provinces
./tools/wikidata/update.sh  all   lowercase   10m_cultural  ne_10m_airports
./tools/wikidata/update.sh  all   lowercase   10m_cultural  ne_10m_populated_places
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_geographic_lines
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_geography_marine_polys
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_geography_regions_elevation_points
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_geography_regions_points
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_geography_regions_polys
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_lakes_europe
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_lakes_historic
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_lakes_north_america
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_lakes
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_playas
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_rivers_europe
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_rivers_lake_centerlines_scale_rank
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_rivers_lake_centerlines
./tools/wikidata/update.sh  all   lowercase   10m_physical  ne_10m_rivers_north_america
./tools/wikidata/update.sh  all   lowercase   10m_cultural  ne_10m_admin_1_label_points_details
# == 50m ================= |==== |==========| ============| ================================================
./tools/wikidata/update.sh  all   uppercase   50m_cultural  ne_50m_admin_0_sovereignty
./tools/wikidata/update.sh  all   uppercase   50m_cultural  ne_50m_admin_0_countries
./tools/wikidata/update.sh  all   uppercase   50m_cultural  ne_50m_admin_0_countries_lakes
./tools/wikidata/update.sh  all   uppercase   50m_cultural  ne_50m_admin_0_map_units
./tools/wikidata/update.sh  all   uppercase   50m_cultural  ne_50m_admin_0_map_subunits
./tools/wikidata/update.sh  all   uppercase   50m_cultural  ne_50m_admin_0_tiny_countries
#./tools/wikidata/update.sh all   uppercase   50m_cultural  ne_50m_admin_0_breakaway_disputed_areas             # KeyError: 'WIKIDATAID'  
#./tools/wikidata/update.sh all   uppercase   50m_cultural  ne_50m_admin_0_breakaway_disputed_areas_scale_rank  # KeyError: 'WIKIDATAID'  
./tools/wikidata/update.sh  all   lowercase   50m_cultural  ne_50m_admin_1_states_provinces
./tools/wikidata/update.sh  all   lowercase   50m_cultural  ne_50m_admin_1_states_provinces_lakes
./tools/wikidata/update.sh  all   lowercase   50m_physical  ne_50m_lakes
./tools/wikidata/update.sh  all   lowercase   50m_physical  ne_50m_lakes_historic
./tools/wikidata/update.sh  all   lowercase   50m_physical  ne_50m_playas
./tools/wikidata/update.sh  all   lowercase   50m_physical  ne_50m_rivers_lake_centerlines
./tools/wikidata/update.sh  all   lowercase   50m_physical  ne_50m_rivers_lake_centerlines_scale_rank
# ==110m ================= |==== |==========| ============| ================================================
./tools/wikidata/update.sh  all   uppercase   110m_cultural ne_110m_admin_0_sovereignty
./tools/wikidata/update.sh  all   uppercase   110m_cultural ne_110m_admin_0_countries
./tools/wikidata/update.sh  all   uppercase   110m_cultural ne_110m_admin_0_countries_lakes
./tools/wikidata/update.sh  all   uppercase   110m_cultural ne_110m_admin_0_map_units
./tools/wikidata/update.sh  all   lowercase   110m_cultural ne_110m_admin_1_states_provinces
./tools/wikidata/update.sh  all   lowercase   110m_cultural ne_110m_admin_1_states_provinces_lakes
./tools/wikidata/update.sh  all   lowercase   110m_physical ne_110m_lakes
./tools/wikidata/update.sh  all   lowercase   110m_physical ne_110m_rivers_lake_centerlines
# ======================== |==== |==========| ============| ================================================

# show summary
cat   x_tempshape/update.md

# list new files
ls -Gga   x_tempshape/*/*

# Run the final update process
make clean all

echo " ---- end of run_all.sh ------ "
ls -Gga $log_file