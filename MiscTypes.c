#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* Copyright (C) 1997, Kenneth Albanowski.
   This code may be distributed under the same terms as Perl itself. */

#include "MiscTypes.h"

void CroakOpts(char * name, char * value, struct opts * o)
{
	SV * result = sv_newmortal();
	char buffer[40];
	int i;
	
	sprintf(buffer, "invalid %s %s, expecting", name, value);
	sv_catpv(result, buffer);
	for(i=0;o[i].name;i++) {
		if (i==0)
			sv_catpv(result," '");
		else if (o[i+1].name)
			sv_catpv(result,"', '");
		else
			sv_catpv(result,"', or '");
		sv_catpv(result, o[i].name);
	}
	sv_catpv(result,"'");
	croak(SvPV(result, na));
}

long SvOpt(SV * name, char * optname, struct opts * o) 
{
	int i;
	char * n = SvPV(name, na);
	for(i=0;o[i].name;i++) 
		if (strEQ(o[i].name, n))
			return o[i].value;
	CroakOpts(optname, n, o);
}

SV * newSVOpt(long value, char * optname, struct opts * o) 
{
	int i;
	for(i=0;o[i].name;i++)
		if (o[i].value == value)
			return newSVpv(o[i].name, 0);
	croak("invalid %s value %d", optname, value);
}

SV * newSVMiscRef(void * object, char * classname, int * newref)
{
	SV * result = RetrieveMisc(object);
	if (result) {
		result = newRV(result);
		//SvREFCNT_dec(SvRV(result));
		if (newref)
			*newref = 0;
	} else {
		result = newRV(newSViv((int)object));
		RegisterMisc(SvRV(result), object);
		sv_bless(result, gv_stashpv(classname, FALSE));
		SvREFCNT_dec(SvRV(result));
		if (newref)
			*newref = 1;
	}
	return result;
}


long SvOptFlags(SV * name, char * optname, struct opts * o) 
{
	int i;
	int val=0;
	if (!name || !SvOK(name))
		return 0;
	if (SvRV(name) && (SvTYPE(SvRV(name)) == SVt_PVAV)) {
		AV * r = (AV*)SvRV(name);
		for(i=0;i<=av_len(r);i++)
			val |= SvOpt(*av_fetch(r, i, 0), optname, o);
	} else if (SvRV(name) && (SvTYPE(SvRV(name)) == SVt_PVHV)) {
		HV * r = (HV*)SvRV(name);
		/* This is bad, as we don't catch members with invalid names */
		for(i=0;o[i].name;i++) {
			SV ** s = hv_fetch(r, o[i].name, strlen(o[i].name), 0);
			if (s && SvOK(*s) && SvTRUE(*s))
				val |= o[i].value;
		}
	} else
		val |= SvOpt(name, optname, o);
	return val;
}

SV * newSVOptFlags(long value, char * optname, struct opts * o, int hash) 
{
	SV * result;
	if (hash) {
		HV * h = newHV();
		int i;
		result = newRV((SV*)h);
		SvREFCNT_dec(h);
		for(i=0;o[i].name;i++)
			if ((value & o[i].value) == o[i].value) {
				hv_store(h, o[i].name, strlen(o[i].name), newSViv(1), 0);
				value &= ~o[i].value;
			}
	} else {
		AV * a = newAV();
		int i;
		result = newRV((SV*)a);
		SvREFCNT_dec(a);
		for(i=0;o[i].name;i++)
			if ((value & o[i].value) == o[i].value) {
				av_push(a, newSVpv(o[i].name, 0));
				value &= ~o[i].value;
			}
	}
	return result;
}


void * SvMiscRef(SV * o, char * classname)
{
	if (!o || !SvOK(o))
		return 0;
	if (classname && !sv_derived_from(o, classname))
		croak("variable is not of type %s", classname);
	return (void*)SvIV((SV*)SvRV(o));
}

static HV * MiscCache = 0;

void UnregisterMisc(SV * sv_object, void * gtk_object)
{
	int i;
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);
	if (!MiscCache)
		MiscCache = newHV();
	sv_setiv(sv_object, 0);
	SvREFCNT(sv_object)+=2;
	hv_delete(MiscCache, buffer, strlen(buffer), G_DISCARD);
	SvREFCNT(sv_object)--;
}

void RegisterMisc(SV * sv_object, void * gtk_object)
{
	char buffer[40];
	sprintf(buffer, "%lu", (unsigned long)gtk_object);
	if (!MiscCache)
		MiscCache = newHV();
	hv_store(MiscCache, buffer, strlen(buffer), sv_object, 0);
}

SV * RetrieveMisc(void * gtk_object)
{
	SV ** s;
	char buffer[40];
	if (!MiscCache)
		MiscCache = newHV();
	sprintf(buffer, "%lu", (unsigned long)gtk_object);
	s = hv_fetch(MiscCache, buffer, strlen(buffer), 0);
	if (s)
		return *s;
	else
		return 0;
}

void * alloc_temp(int size)
{
    SV * s = sv_2mortal(newSVpv("",0));
    SvGROW(s, size);
    return SvPV(s, na);
}
            