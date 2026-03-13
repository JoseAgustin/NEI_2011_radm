# NEI_2011_radm — NEI 2011 Binary Emissions Converter for WRF-Chem RADM2

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Language: Fortran](https://img.shields.io/badge/Language-Fortran%2090-orange.svg)]()
[![WRF-Chem](https://img.shields.io/badge/Model-WRF--Chem-lightblue.svg)](https://ruc.noaa.gov/wrf/wrf-chem/)
[![Mechanism](https://img.shields.io/badge/Mechanism-RADM2-green.svg)]()

> Reads the binary `wrfem` emission files from the **U.S. EPA National Emissions Inventory 2011 (NEI 2011)** pre-processed for WRF-Chem, and converts them into NetCDF `wrfchemi` files formatted for the **RADM2** chemical mechanism (`chem_opt = 2`).

---

## Table of Contents

- [Background](#background)
- [Requirements](#requirements)
- [Installation](#installation)
- [Repository Structure](#repository-structure)
- [Input Files](#input-files)
  - [wrfem binary emission files](#wrfem-binary-emission-files)
  - [wrfinput](#wrfinput)
  - [domain.nml](#domainnml)
- [Output Files](#output-files)
- [Usage](#usage)
- [WRF-Chem Configuration](#wrf-chem-configuration)
- [Obtaining the NEI 2011 Emission Data](#obtaining-the-nei-2011-emission-data)
- [RADM2 Emission Species](#radm2-emission-species)
- [Source Code Overview](#source-code-overview)
- [References](#references)

---

## Background

The **National Emissions Inventory (NEI)** is a comprehensive and detailed estimate of air emissions of criteria pollutants and hazardous air pollutants from all source categories across the United States, compiled by the U.S. EPA every three years. The 2011 NEI is a widely used base year for air quality modeling studies over North American domains.

The NOAA/ESRL Global Systems Division (GSD) distributes pre-processed NEI 2011 emissions in a flat Fortran binary format (`wrfem_*`) ready for ingestion into the WRF-Chem emissions converter (`convert_emiss.exe`). However, working directly with the standard `convert_emiss.exe` pipeline can be cumbersome when only the RADM2 mechanism is needed.

`NEI_2011_radm` provides a lightweight Fortran tool that reads those binary files directly and writes CF-annotated NetCDF `wrfchemi` files — the emission input files consumed by WRF-Chem at run time — without requiring a full WPS/WRF build environment.

---

## Requirements

| Component | Notes |
|---|---|
| Fortran compiler | `gfortran` ≥ 6 or Intel `ifort` ≥ 17 |
| NetCDF-Fortran | Version 4+ with Fortran bindings |
| Autotools | `autoconf` and `automake` for the build system |

---

## Installation

```bash
# 1. Clone the repository
git clone https://github.com/JoseAgustin/NEI_2011_radm.git
cd NEI_2011_radm/source

# 2. Configure the build environment
./configure

# 3. Compile
make
```

The compiled executable is placed in the `source/` directory. If NetCDF is installed in a non-standard location, pass the paths explicitly:

```bash
./configure FCFLAGS="-I/path/to/netcdf/include" LDFLAGS="-L/path/to/netcdf/lib"
```

---

## Repository Structure

```
NEI_2011_radm/
├── source/          # Fortran 90 source code and build scripts
├── Doc/             # Technical documentation
├── domain.nml       # Example domain namelist (edit before running)
├── LICENSE          # GPL-3.0 license
└── README.md        # This file
```

---

## Input Files

All four input files must be present in the working directory when the converter is executed.

### `wrfem` binary emission files

Two flat Fortran binary files distributed by NOAA/GSD as part of the NEI 2011 WRF-Chem pre-processed dataset:

| File | Time coverage | Description |
|---|---|---|
| `wrfem_00to12z_d01` | Hours 1–12 UTC | Binary emission array for the first half-day |
| `wrfem_12to24z_d01` | Hours 13–24 UTC | Binary emission array for the second half-day |

Each file contains three-dimensional arrays (West–East × South–North × vertical levels) for each emitted chemical species in the RADM2 mechanism. The binary layout uses direct-access Fortran unformatted records.

> **Data source:** These files are obtained from the NOAA/GSD anonymous FTP server — see [Obtaining the NEI 2011 Emission Data](#obtaining-the-nei-2011-emission-data).

### `wrfinput`

A standard WRF `wrfinput_d01` file for the target domain, produced by `real.exe` from WPS output. The converter reads domain dimensions, map projection, and coordinate metadata from this file and writes them into the output NetCDF headers. The spatial grid of `wrfinput` must match the grid of the `wrfem` files.

### `domain.nml`

Fortran namelist specifying the grid dimensions of the `wrfem` files. These must match the dimensions in `wrfinput`:

```fortran
&dom_dims
  IX = 352    ! Number of grid cells in the West–East direction
  JX = 225    ! Number of grid cells in the South–North direction
  KX = 8      ! Number of vertical (eta) levels
/
```

Edit this file to match your domain before running the converter.

---

## Output Files

The converter writes two NetCDF files compatible with WRF-Chem:

| File | Time coverage | Description |
|---|---|---|
| `wrfchemi_00z_d01` | Hours 00–11 UTC | NetCDF emission file for the first half-day |
| `wrfchemi_12z_d01` | Hours 12–23 UTC | NetCDF emission file for the second half-day |

Each output file contains:
- **Dimensions and coordinate variables** copied from `wrfinput` (domain, map projection, latitude/longitude grids).
- **Global attributes** matching WRF-Chem conventions (projection parameters, grid spacing, `CEN_LAT`, `CEN_LON`, `TRUELAT1`, `TRUELAT2`, `STAND_LON`, etc.).
- **Emission variables** for each RADM2 species (see [RADM2 Emission Species](#radm2-emission-species)), with units of mol km⁻² hr⁻¹ for gases and µg m⁻² s⁻¹ for aerosols.

---

## Usage

```bash
# 1. Edit domain.nml to match your domain dimensions
# 2. Ensure wrfem_00to12z_d01, wrfem_12to24z_d01, and wrfinput
#    are present in the working directory
# 3. Run the converter
./source/nei2011_radm.exe
```

The output files `wrfchemi_00z_d01` and `wrfchemi_12z_d01` are written to the working directory.

---

## WRF-Chem Configuration

After generating the `wrfchemi` files, configure `namelist.input` in your WRF-Chem run directory as follows to use RADM2 with NEI 2011 anthropogenic emissions:

```fortran
&chem
  chem_opt          = 2      ! RADM2 gas-phase + MADE/SORGAM aerosols
  emiss_opt         = 2      ! Use wrfchemi emission files
  emiss_inpt_opt    = 1      ! RADM2 emission speciation
  io_style_emissions = 1     ! Single wrfchemi file per 12-hour period
/
```

Link or copy the output files into the WRF run directory:

```bash
ln -sf /path/to/wrfchemi_00z_d01 wrfchemi_00z_d01
ln -sf /path/to/wrfchemi_12z_d01 wrfchemi_12z_d01
```

> **Note:** For domains with multiple nests, repeat the conversion for each domain using the corresponding `wrfem_*_d02`, `wrfem_*_d03`, etc. files, updating `domain.nml` and `wrfinput` accordingly for each nest.

---

## Obtaining the NEI 2011 Emission Data

The pre-processed NEI 2011 binary emission files for WRF-Chem are distributed by the NOAA Global Systems Division via anonymous FTP:

```bash
ftp aftp.fsl.noaa.gov
# Username: anonymous
# Password: your_email@example.com

cd divisions/taq
# Navigate to the NEI 2011 data directory
```

The FTP server is accessible only via a command-line FTP client — standard web browsers cannot connect. If `ftp` is not available on your system, use `lftp` or `ncftp`:

```bash
lftp -u anonymous,your_email@example.com aftp.fsl.noaa.gov
cd divisions/taq
```

> **Note:** As of 2024, some NOAA FTP paths have been reorganised. If the path above is unavailable, check the [WRF-Chem tools page](https://www2.acom.ucar.edu/wrf-chem/wrf-chem-tools-community) or the [NOAA/ESRL WRF-Chem tutorial page](https://ruc.noaa.gov/wrf/wrf-chem/) for updated data locations.

---

## RADM2 Emission Species

The RADM2 mechanism (`chem_opt = 2`) requires the following anthropogenic emission variables in `wrfchemi`. Units are **mol km⁻² hr⁻¹** for gas-phase species and **µg m⁻² s⁻¹** for aerosol species.

### Gas-phase species

| Variable | Description | RADM2 lumping notes |
|---|---|---|
| `E_SO2` | Sulfur dioxide | Direct |
| `E_NO` | Nitric oxide | Fraction of total NOx |
| `E_NO2` | Nitrogen dioxide | Fraction of total NOx |
| `E_CO` | Carbon monoxide | Direct |
| `E_NH3` | Ammonia | Direct |
| `E_HC3` | Alkanes (C3–C5 range) | Lumped from VOC speciation |
| `E_HC5` | Alkanes (C5–C8 range) | Lumped from VOC speciation |
| `E_HC8` | Alkanes (>C8) | Lumped from VOC speciation |
| `E_ETH` | Ethene | Direct |
| `E_OL2` | Terminal alkenes | Lumped |
| `E_OLT` | Internal alkenes | Lumped |
| `E_OLI` | Isoprene-type alkenes | Lumped |
| `E_TOL` | Toluene and less-reactive aromatics | Lumped |
| `E_XYL` | Xylene and more-reactive aromatics | Lumped |
| `E_HCHO` | Formaldehyde | Direct |
| `E_ALD` | Higher aldehydes (C≥2) | Lumped |
| `E_KET` | Ketones | Lumped |
| `E_ORA2` | Higher carboxylic acids | Lumped |

### Aerosol species (MADE/SORGAM, used with `chem_opt = 2`)

| Variable | Description |
|---|---|
| `E_PM25` | Fine particulate matter (PM2.5) |
| `E_PM10` | Coarse particulate matter (PM10) |
| `E_PM_25` | Primary PM2.5 for MADE scheme |

> The RADM2 mechanism treats NOx as NO + NO2 only. Total NOx from the NEI is split into NO and NO2 fractions using the `fracref` reference values defined in the WRF-Chem registry.

---

## Source Code Overview

| File | Description |
|---|---|
| `source/nei2011_radm.F90` | Main program: reads `domain.nml`, opens binary and `wrfinput` files, writes `wrfchemi` NetCDF output |
| `source/Makefile.am` | Automake configuration |
| `source/configure.ac` | Autoconf configuration |

Technical documentation generated by Doxygen (if available) is stored in the `Doc/` directory.

---

## References

- U.S. EPA (2015). *2011 National Emissions Inventory (NEI) — Technical Support Document*. U.S. Environmental Protection Agency, Office of Air Quality Planning and Standards.  
  https://www.epa.gov/air-emissions-inventories/2011-national-emissions-inventory-nei-data

- Grell, G. A., Peckham, S. E., Schmitz, R., McKeen, S. A., Frost, G. J., Skamarock, W. C., & Eder, B. K. (2005). Fully coupled "online" chemistry within the WRF model. *Atmospheric Environment*, **39**, 6957–6975.  
  https://doi.org/10.1016/j.atmosenv.2005.04.027

- Stockwell, W. R., Middleton, P., Chang, J. S., & Tang, X. (1990). The second generation regional acid deposition model chemical mechanism for regional air quality modeling. *Journal of Geophysical Research: Atmospheres*, **95**(D10), 16343–16367.  
  https://doi.org/10.1029/JD095iD10p16343

- NOAA/GSD WRF-Chem Tutorial Exercises.  
  https://ruc.noaa.gov/wrf/wrf-chem/

---

*README last updated: March 2026*
