extern HV * pGtkType[];
extern char * pGtkTypeName[];
extern HV * pG_EnumHash;
extern HV * pG_FlagsHash;
extern AV * gtk_typecasts;
extern int type_name(char * name);

extern void add_typecast(int type, char * perlName);
extern SV * GtkGetArg(GtkArg * a);
extern void GtkSetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object);
extern void GtkSetRetArg(GtkArg * a, SV * v, SV * Class, GtkObject * Object);

/*extern SV * newSVOptsHash(long value, char * name, HV * hash);
extern long SvOptsHash(SV * value, char * name, HV * hash);
extern SV * newSVFlagsHash(long value, char * name, HV * hash, int);
extern long SvFlagsHash(SV * value, char * name, HV * hash);*/

#define pGE_GdkAxisUse pGtkType[0]
#define pGEName_GdkAxisUse pGtkTypeName[0]
#define newSVGdkAxisUse(v) newSVOptsHash(v, pGEName_GdkAxisUse, pGE_GdkAxisUse)
#define SvGdkAxisUse(v) SvOptsHash(v, pGEName_GdkAxisUse, pGE_GdkAxisUse)
#define Gtk__Gdk__AxisUse GdkAxisUse
#define pGE_GdkByteOrder pGtkType[1]
#define pGEName_GdkByteOrder pGtkTypeName[1]
#define newSVGdkByteOrder(v) newSVOptsHash(v, pGEName_GdkByteOrder, pGE_GdkByteOrder)
#define SvGdkByteOrder(v) SvOptsHash(v, pGEName_GdkByteOrder, pGE_GdkByteOrder)
#define Gtk__Gdk__ByteOrder GdkByteOrder
#define pGE_GdkCapStyle pGtkType[2]
#define pGEName_GdkCapStyle pGtkTypeName[2]
#define newSVGdkCapStyle(v) newSVOptsHash(v, pGEName_GdkCapStyle, pGE_GdkCapStyle)
#define SvGdkCapStyle(v) SvOptsHash(v, pGEName_GdkCapStyle, pGE_GdkCapStyle)
#define Gtk__Gdk__CapStyle GdkCapStyle
#define pGE_GdkCursorType pGtkType[3]
#define pGEName_GdkCursorType pGtkTypeName[3]
#define newSVGdkCursorType(v) newSVOptsHash(v, pGEName_GdkCursorType, pGE_GdkCursorType)
#define SvGdkCursorType(v) SvOptsHash(v, pGEName_GdkCursorType, pGE_GdkCursorType)
#define Gtk__Gdk__CursorType GdkCursorType
#define pGE_GdkDndType pGtkType[4]
#define pGEName_GdkDndType pGtkTypeName[4]
#define newSVGdkDndType(v) newSVOptsHash(v, pGEName_GdkDndType, pGE_GdkDndType)
#define SvGdkDndType(v) SvOptsHash(v, pGEName_GdkDndType, pGE_GdkDndType)
#define Gtk__Gdk__DndType GdkDndType
#define pGE_GdkEventType pGtkType[5]
#define pGEName_GdkEventType pGtkTypeName[5]
#define newSVGdkEventType(v) newSVOptsHash(v, pGEName_GdkEventType, pGE_GdkEventType)
#define SvGdkEventType(v) SvOptsHash(v, pGEName_GdkEventType, pGE_GdkEventType)
#define Gtk__Gdk__EventType GdkEventType
#define pGE_GdkFill pGtkType[6]
#define pGEName_GdkFill pGtkTypeName[6]
#define newSVGdkFill(v) newSVOptsHash(v, pGEName_GdkFill, pGE_GdkFill)
#define SvGdkFill(v) SvOptsHash(v, pGEName_GdkFill, pGE_GdkFill)
#define Gtk__Gdk__Fill GdkFill
#define pGE_GdkFunction pGtkType[7]
#define pGEName_GdkFunction pGtkTypeName[7]
#define newSVGdkFunction(v) newSVOptsHash(v, pGEName_GdkFunction, pGE_GdkFunction)
#define SvGdkFunction(v) SvOptsHash(v, pGEName_GdkFunction, pGE_GdkFunction)
#define Gtk__Gdk__Function GdkFunction
#define pGE_GdkImageType pGtkType[8]
#define pGEName_GdkImageType pGtkTypeName[8]
#define newSVGdkImageType(v) newSVOptsHash(v, pGEName_GdkImageType, pGE_GdkImageType)
#define SvGdkImageType(v) SvOptsHash(v, pGEName_GdkImageType, pGE_GdkImageType)
#define Gtk__Gdk__ImageType GdkImageType
#define pGE_GdkInputMode pGtkType[9]
#define pGEName_GdkInputMode pGtkTypeName[9]
#define newSVGdkInputMode(v) newSVOptsHash(v, pGEName_GdkInputMode, pGE_GdkInputMode)
#define SvGdkInputMode(v) SvOptsHash(v, pGEName_GdkInputMode, pGE_GdkInputMode)
#define Gtk__Gdk__InputMode GdkInputMode
#define pGE_GdkInputSource pGtkType[10]
#define pGEName_GdkInputSource pGtkTypeName[10]
#define newSVGdkInputSource(v) newSVOptsHash(v, pGEName_GdkInputSource, pGE_GdkInputSource)
#define SvGdkInputSource(v) SvOptsHash(v, pGEName_GdkInputSource, pGE_GdkInputSource)
#define Gtk__Gdk__InputSource GdkInputSource
#define pGE_GdkJoinStyle pGtkType[11]
#define pGEName_GdkJoinStyle pGtkTypeName[11]
#define newSVGdkJoinStyle(v) newSVOptsHash(v, pGEName_GdkJoinStyle, pGE_GdkJoinStyle)
#define SvGdkJoinStyle(v) SvOptsHash(v, pGEName_GdkJoinStyle, pGE_GdkJoinStyle)
#define Gtk__Gdk__JoinStyle GdkJoinStyle
#define pGE_GdkLineStyle pGtkType[12]
#define pGEName_GdkLineStyle pGtkTypeName[12]
#define newSVGdkLineStyle(v) newSVOptsHash(v, pGEName_GdkLineStyle, pGE_GdkLineStyle)
#define SvGdkLineStyle(v) SvOptsHash(v, pGEName_GdkLineStyle, pGE_GdkLineStyle)
#define Gtk__Gdk__LineStyle GdkLineStyle
#define pGE_GdkNotifyType pGtkType[13]
#define pGEName_GdkNotifyType pGtkTypeName[13]
#define newSVGdkNotifyType(v) newSVOptsHash(v, pGEName_GdkNotifyType, pGE_GdkNotifyType)
#define SvGdkNotifyType(v) SvOptsHash(v, pGEName_GdkNotifyType, pGE_GdkNotifyType)
#define Gtk__Gdk__NotifyType GdkNotifyType
#define pGE_GdkPropMode pGtkType[14]
#define pGEName_GdkPropMode pGtkTypeName[14]
#define newSVGdkPropMode(v) newSVOptsHash(v, pGEName_GdkPropMode, pGE_GdkPropMode)
#define SvGdkPropMode(v) SvOptsHash(v, pGEName_GdkPropMode, pGE_GdkPropMode)
#define Gtk__Gdk__PropMode GdkPropMode
#define pGE_GdkPropertyState pGtkType[15]
#define pGEName_GdkPropertyState pGtkTypeName[15]
#define newSVGdkPropertyState(v) newSVOptsHash(v, pGEName_GdkPropertyState, pGE_GdkPropertyState)
#define SvGdkPropertyState(v) SvOptsHash(v, pGEName_GdkPropertyState, pGE_GdkPropertyState)
#define Gtk__Gdk__PropertyState GdkPropertyState
#define pGE_GdkSelection pGtkType[16]
#define pGEName_GdkSelection pGtkTypeName[16]
#define newSVGdkSelection(v) newSVOptsHash(v, pGEName_GdkSelection, pGE_GdkSelection)
#define SvGdkSelection(v) SvOptsHash(v, pGEName_GdkSelection, pGE_GdkSelection)
#define Gtk__Gdk__Selection GdkSelection
#define pGE_GdkStatus pGtkType[17]
#define pGEName_GdkStatus pGtkTypeName[17]
#define newSVGdkStatus(v) newSVOptsHash(v, pGEName_GdkStatus, pGE_GdkStatus)
#define SvGdkStatus(v) SvOptsHash(v, pGEName_GdkStatus, pGE_GdkStatus)
#define Gtk__Gdk__Status GdkStatus
#define pGE_GdkSubwindowMode pGtkType[18]
#define pGEName_GdkSubwindowMode pGtkTypeName[18]
#define newSVGdkSubwindowMode(v) newSVOptsHash(v, pGEName_GdkSubwindowMode, pGE_GdkSubwindowMode)
#define SvGdkSubwindowMode(v) SvOptsHash(v, pGEName_GdkSubwindowMode, pGE_GdkSubwindowMode)
#define Gtk__Gdk__SubwindowMode GdkSubwindowMode
#define pGE_GdkVisualType pGtkType[19]
#define pGEName_GdkVisualType pGtkTypeName[19]
#define newSVGdkVisualType(v) newSVOptsHash(v, pGEName_GdkVisualType, pGE_GdkVisualType)
#define SvGdkVisualType(v) SvOptsHash(v, pGEName_GdkVisualType, pGE_GdkVisualType)
#define Gtk__Gdk__VisualType GdkVisualType
#define pGE_GdkWindowClass pGtkType[20]
#define pGEName_GdkWindowClass pGtkTypeName[20]
#define newSVGdkWindowClass(v) newSVOptsHash(v, pGEName_GdkWindowClass, pGE_GdkWindowClass)
#define SvGdkWindowClass(v) SvOptsHash(v, pGEName_GdkWindowClass, pGE_GdkWindowClass)
#define Gtk__Gdk__WindowClass GdkWindowClass
#define pGE_GdkWindowType pGtkType[21]
#define pGEName_GdkWindowType pGtkTypeName[21]
#define newSVGdkWindowType(v) newSVOptsHash(v, pGEName_GdkWindowType, pGE_GdkWindowType)
#define SvGdkWindowType(v) SvOptsHash(v, pGEName_GdkWindowType, pGE_GdkWindowType)
#define Gtk__Gdk__WindowType GdkWindowType
#define pGE_GtkArrowType pGtkType[22]
#define pGEName_GtkArrowType pGtkTypeName[22]
#define newSVGtkArrowType(v) newSVOptsHash(v, pGEName_GtkArrowType, pGE_GtkArrowType)
#define SvGtkArrowType(v) SvOptsHash(v, pGEName_GtkArrowType, pGE_GtkArrowType)
#define Gtk__ArrowType GtkArrowType
#define pGE_GtkCurveType pGtkType[23]
#define pGEName_GtkCurveType pGtkTypeName[23]
#define newSVGtkCurveType(v) newSVOptsHash(v, pGEName_GtkCurveType, pGE_GtkCurveType)
#define SvGtkCurveType(v) SvOptsHash(v, pGEName_GtkCurveType, pGE_GtkCurveType)
#define Gtk__CurveType GtkCurveType
#define pGE_GtkDirectionType pGtkType[24]
#define pGEName_GtkDirectionType pGtkTypeName[24]
#define newSVGtkDirectionType(v) newSVOptsHash(v, pGEName_GtkDirectionType, pGE_GtkDirectionType)
#define SvGtkDirectionType(v) SvOptsHash(v, pGEName_GtkDirectionType, pGE_GtkDirectionType)
#define Gtk__DirectionType GtkDirectionType
#define pGE_GtkJustification pGtkType[25]
#define pGEName_GtkJustification pGtkTypeName[25]
#define newSVGtkJustification(v) newSVOptsHash(v, pGEName_GtkJustification, pGE_GtkJustification)
#define SvGtkJustification(v) SvOptsHash(v, pGEName_GtkJustification, pGE_GtkJustification)
#define Gtk__Justification GtkJustification
#define pGE_GtkMenuFactoryType pGtkType[26]
#define pGEName_GtkMenuFactoryType pGtkTypeName[26]
#define newSVGtkMenuFactoryType(v) newSVOptsHash(v, pGEName_GtkMenuFactoryType, pGE_GtkMenuFactoryType)
#define SvGtkMenuFactoryType(v) SvOptsHash(v, pGEName_GtkMenuFactoryType, pGE_GtkMenuFactoryType)
#define Gtk__MenuFactoryType GtkMenuFactoryType
#define pGE_GtkMetricType pGtkType[27]
#define pGEName_GtkMetricType pGtkTypeName[27]
#define newSVGtkMetricType(v) newSVOptsHash(v, pGEName_GtkMetricType, pGE_GtkMetricType)
#define SvGtkMetricType(v) SvOptsHash(v, pGEName_GtkMetricType, pGE_GtkMetricType)
#define Gtk__MetricType GtkMetricType
#define pGE_GtkPackType pGtkType[28]
#define pGEName_GtkPackType pGtkTypeName[28]
#define newSVGtkPackType(v) newSVOptsHash(v, pGEName_GtkPackType, pGE_GtkPackType)
#define SvGtkPackType(v) SvOptsHash(v, pGEName_GtkPackType, pGE_GtkPackType)
#define Gtk__PackType GtkPackType
#define pGE_GtkPolicyType pGtkType[29]
#define pGEName_GtkPolicyType pGtkTypeName[29]
#define newSVGtkPolicyType(v) newSVOptsHash(v, pGEName_GtkPolicyType, pGE_GtkPolicyType)
#define SvGtkPolicyType(v) SvOptsHash(v, pGEName_GtkPolicyType, pGE_GtkPolicyType)
#define Gtk__PolicyType GtkPolicyType
#define pGE_GtkPositionType pGtkType[30]
#define pGEName_GtkPositionType pGtkTypeName[30]
#define newSVGtkPositionType(v) newSVOptsHash(v, pGEName_GtkPositionType, pGE_GtkPositionType)
#define SvGtkPositionType(v) SvOptsHash(v, pGEName_GtkPositionType, pGE_GtkPositionType)
#define Gtk__PositionType GtkPositionType
#define pGE_GtkPreviewType pGtkType[31]
#define pGEName_GtkPreviewType pGtkTypeName[31]
#define newSVGtkPreviewType(v) newSVOptsHash(v, pGEName_GtkPreviewType, pGE_GtkPreviewType)
#define SvGtkPreviewType(v) SvOptsHash(v, pGEName_GtkPreviewType, pGE_GtkPreviewType)
#define Gtk__PreviewType GtkPreviewType
#define pGE_GtkScrollType pGtkType[32]
#define pGEName_GtkScrollType pGtkTypeName[32]
#define newSVGtkScrollType(v) newSVOptsHash(v, pGEName_GtkScrollType, pGE_GtkScrollType)
#define SvGtkScrollType(v) SvOptsHash(v, pGEName_GtkScrollType, pGE_GtkScrollType)
#define Gtk__ScrollType GtkScrollType
#define pGE_GtkSelectionMode pGtkType[33]
#define pGEName_GtkSelectionMode pGtkTypeName[33]
#define newSVGtkSelectionMode(v) newSVOptsHash(v, pGEName_GtkSelectionMode, pGE_GtkSelectionMode)
#define SvGtkSelectionMode(v) SvOptsHash(v, pGEName_GtkSelectionMode, pGE_GtkSelectionMode)
#define Gtk__SelectionMode GtkSelectionMode
#define pGE_GtkShadowType pGtkType[34]
#define pGEName_GtkShadowType pGtkTypeName[34]
#define newSVGtkShadowType(v) newSVOptsHash(v, pGEName_GtkShadowType, pGE_GtkShadowType)
#define SvGtkShadowType(v) SvOptsHash(v, pGEName_GtkShadowType, pGE_GtkShadowType)
#define Gtk__ShadowType GtkShadowType
#define pGE_GtkStateType pGtkType[35]
#define pGEName_GtkStateType pGtkTypeName[35]
#define newSVGtkStateType(v) newSVOptsHash(v, pGEName_GtkStateType, pGE_GtkStateType)
#define SvGtkStateType(v) SvOptsHash(v, pGEName_GtkStateType, pGE_GtkStateType)
#define Gtk__StateType GtkStateType
#define pGE_GtkSubmenuDirection pGtkType[36]
#define pGEName_GtkSubmenuDirection pGtkTypeName[36]
#define newSVGtkSubmenuDirection(v) newSVOptsHash(v, pGEName_GtkSubmenuDirection, pGE_GtkSubmenuDirection)
#define SvGtkSubmenuDirection(v) SvOptsHash(v, pGEName_GtkSubmenuDirection, pGE_GtkSubmenuDirection)
#define Gtk__SubmenuDirection GtkSubmenuDirection
#define pGE_GtkSubmenuPlacement pGtkType[37]
#define pGEName_GtkSubmenuPlacement pGtkTypeName[37]
#define newSVGtkSubmenuPlacement(v) newSVOptsHash(v, pGEName_GtkSubmenuPlacement, pGE_GtkSubmenuPlacement)
#define SvGtkSubmenuPlacement(v) SvOptsHash(v, pGEName_GtkSubmenuPlacement, pGE_GtkSubmenuPlacement)
#define Gtk__SubmenuPlacement GtkSubmenuPlacement
#define pGE_GtkTroughType pGtkType[38]
#define pGEName_GtkTroughType pGtkTypeName[38]
#define newSVGtkTroughType(v) newSVOptsHash(v, pGEName_GtkTroughType, pGE_GtkTroughType)
#define SvGtkTroughType(v) SvOptsHash(v, pGEName_GtkTroughType, pGE_GtkTroughType)
#define Gtk__TroughType GtkTroughType
#define pGE_GtkUpdateType pGtkType[39]
#define pGEName_GtkUpdateType pGtkTypeName[39]
#define newSVGtkUpdateType(v) newSVOptsHash(v, pGEName_GtkUpdateType, pGE_GtkUpdateType)
#define SvGtkUpdateType(v) SvOptsHash(v, pGEName_GtkUpdateType, pGE_GtkUpdateType)
#define Gtk__UpdateType GtkUpdateType
#define pGE_GtkWindowPosition pGtkType[40]
#define pGEName_GtkWindowPosition pGtkTypeName[40]
#define newSVGtkWindowPosition(v) newSVOptsHash(v, pGEName_GtkWindowPosition, pGE_GtkWindowPosition)
#define SvGtkWindowPosition(v) SvOptsHash(v, pGEName_GtkWindowPosition, pGE_GtkWindowPosition)
#define Gtk__WindowPosition GtkWindowPosition
#define pGE_GtkWindowType pGtkType[41]
#define pGEName_GtkWindowType pGtkTypeName[41]
#define newSVGtkWindowType(v) newSVOptsHash(v, pGEName_GtkWindowType, pGE_GtkWindowType)
#define SvGtkWindowType(v) SvOptsHash(v, pGEName_GtkWindowType, pGE_GtkWindowType)
#define Gtk__WindowType GtkWindowType
#define pGF_GdkEventMask pGtkType[42]
#define pGFName_GdkEventMask pGtkTypeName[42]
#define newSVGdkEventMask(v) newSVFlagsHash(v, pGFName_GdkEventMask, pGF_GdkEventMask, 1)
#define SvGdkEventMask(v) SvFlagsHash(v, pGFName_GdkEventMask, pGF_GdkEventMask)
#define Gtk__Gdk__EventMask GdkEventMask
#define pGF_GdkGCValuesMask pGtkType[43]
#define pGFName_GdkGCValuesMask pGtkTypeName[43]
#define newSVGdkGCValuesMask(v) newSVFlagsHash(v, pGFName_GdkGCValuesMask, pGF_GdkGCValuesMask, 1)
#define SvGdkGCValuesMask(v) SvFlagsHash(v, pGFName_GdkGCValuesMask, pGF_GdkGCValuesMask)
#define Gtk__Gdk__GCValuesMask GdkGCValuesMask
#define pGF_GdkInputCondition pGtkType[44]
#define pGFName_GdkInputCondition pGtkTypeName[44]
#define newSVGdkInputCondition(v) newSVFlagsHash(v, pGFName_GdkInputCondition, pGF_GdkInputCondition, 1)
#define SvGdkInputCondition(v) SvFlagsHash(v, pGFName_GdkInputCondition, pGF_GdkInputCondition)
#define Gtk__Gdk__InputCondition GdkInputCondition
#define pGF_GdkModifierType pGtkType[45]
#define pGFName_GdkModifierType pGtkTypeName[45]
#define newSVGdkModifierType(v) newSVFlagsHash(v, pGFName_GdkModifierType, pGF_GdkModifierType, 1)
#define SvGdkModifierType(v) SvFlagsHash(v, pGFName_GdkModifierType, pGF_GdkModifierType)
#define Gtk__Gdk__ModifierType GdkModifierType
#define pGF_GdkWindowAttributesType pGtkType[46]
#define pGFName_GdkWindowAttributesType pGtkTypeName[46]
#define newSVGdkWindowAttributesType(v) newSVFlagsHash(v, pGFName_GdkWindowAttributesType, pGF_GdkWindowAttributesType, 1)
#define SvGdkWindowAttributesType(v) SvFlagsHash(v, pGFName_GdkWindowAttributesType, pGF_GdkWindowAttributesType)
#define Gtk__Gdk__WindowAttributesType GdkWindowAttributesType
#define pGF_GdkWindowHints pGtkType[47]
#define pGFName_GdkWindowHints pGtkTypeName[47]
#define newSVGdkWindowHints(v) newSVFlagsHash(v, pGFName_GdkWindowHints, pGF_GdkWindowHints, 1)
#define SvGdkWindowHints(v) SvFlagsHash(v, pGFName_GdkWindowHints, pGF_GdkWindowHints)
#define Gtk__Gdk__WindowHints GdkWindowHints
#define pGF_GtkAttachOptions pGtkType[48]
#define pGFName_GtkAttachOptions pGtkTypeName[48]
#define newSVGtkAttachOptions(v) newSVFlagsHash(v, pGFName_GtkAttachOptions, pGF_GtkAttachOptions, 1)
#define SvGtkAttachOptions(v) SvFlagsHash(v, pGFName_GtkAttachOptions, pGF_GtkAttachOptions)
#define Gtk__AttachOptions GtkAttachOptions
#define pGF_GtkSignalRunType pGtkType[49]
#define pGFName_GtkSignalRunType pGtkTypeName[49]
#define newSVGtkSignalRunType(v) newSVFlagsHash(v, pGFName_GtkSignalRunType, pGF_GtkSignalRunType, 1)
#define SvGtkSignalRunType(v) SvFlagsHash(v, pGFName_GtkSignalRunType, pGF_GtkSignalRunType)
#define Gtk__SignalRunType GtkSignalRunType
#define pGF_GtkWidgetFlags pGtkType[50]
#define pGFName_GtkWidgetFlags pGtkTypeName[50]
#define newSVGtkWidgetFlags(v) newSVFlagsHash(v, pGFName_GtkWidgetFlags, pGF_GtkWidgetFlags, 1)
#define SvGtkWidgetFlags(v) SvFlagsHash(v, pGFName_GtkWidgetFlags, pGF_GtkWidgetFlags)
#define Gtk__WidgetFlags GtkWidgetFlags
extern SV * newSVGdkColormap(GdkColormap * value);
extern GdkColormap * SvGdkColormap(SV * value);
typedef GdkColormap * Gtk__Gdk__Colormap;
extern SV * newSVGdkFont(GdkFont * value);
extern GdkFont * SvGdkFont(SV * value);
typedef GdkFont * Gtk__Gdk__Font;
extern SV * newSVGdkPixmap(GdkPixmap * value);
extern GdkPixmap * SvGdkPixmap(SV * value);
typedef GdkPixmap * Gtk__Gdk__Pixmap;
extern SV * newSVGdkVisual(GdkVisual * value);
extern GdkVisual * SvGdkVisual(SV * value);
typedef GdkVisual * Gtk__Gdk__Visual;
extern SV * newSVGtkAcceleratorTable(GtkAcceleratorTable * value);
extern GtkAcceleratorTable * SvGtkAcceleratorTable(SV * value);
typedef GtkAcceleratorTable * Gtk__AcceleratorTable;
extern SV * newSVGtkStyle(GtkStyle * value);
extern GtkStyle * SvGtkStyle(SV * value);
typedef GtkStyle * Gtk__Style;
extern SV * newSVGtkTooltips(GtkTooltips * value);
extern GtkTooltips * SvGtkTooltips(SV * value);
typedef GtkTooltips * Gtk__Tooltips;
typedef GtkAdjustment * Gtk__Adjustment;
#define CastGtk__Adjustment GTK_ADJUSTMENT
typedef GtkAlignment * Gtk__Alignment;
#define CastGtk__Alignment GTK_ALIGNMENT
typedef GtkArrow * Gtk__Arrow;
#define CastGtk__Arrow GTK_ARROW
typedef GtkAspectFrame * Gtk__AspectFrame;
#define CastGtk__AspectFrame GTK_ASPECT_FRAME
typedef GtkBin * Gtk__Bin;
#define CastGtk__Bin GTK_BIN
typedef GtkBox * Gtk__Box;
#define CastGtk__Box GTK_BOX
typedef GtkButton * Gtk__Button;
#define CastGtk__Button GTK_BUTTON
typedef GtkButtonBox * Gtk__ButtonBox;
#define CastGtk__ButtonBox GTK_BUTTON_BOX
typedef GtkCheckButton * Gtk__CheckButton;
#define CastGtk__CheckButton GTK_CHECK_BUTTON
typedef GtkCheckMenuItem * Gtk__CheckMenuItem;
#define CastGtk__CheckMenuItem GTK_CHECK_MENU_ITEM
typedef GtkColorSelection * Gtk__ColorSelection;
#define CastGtk__ColorSelection GTK_COLOR_SELECTION
typedef GtkColorSelectionDialog * Gtk__ColorSelectionDialog;
#define CastGtk__ColorSelectionDialog GTK_COLOR_SELECTION_DIALOG
typedef GtkContainer * Gtk__Container;
#define CastGtk__Container GTK_CONTAINER
typedef GtkCurve * Gtk__Curve;
#define CastGtk__Curve GTK_CURVE
typedef GtkData * Gtk__Data;
#define CastGtk__Data GTK_DATA
typedef GtkDialog * Gtk__Dialog;
#define CastGtk__Dialog GTK_DIALOG
typedef GtkDrawingArea * Gtk__DrawingArea;
#define CastGtk__DrawingArea GTK_DRAWING_AREA
typedef GtkEntry * Gtk__Entry;
#define CastGtk__Entry GTK_ENTRY
typedef GtkEventBox * Gtk__EventBox;
#define CastGtk__EventBox GTK_EVENT_BOX
typedef GtkFileSelection * Gtk__FileSelection;
#define CastGtk__FileSelection GTK_FILE_SELECTION
typedef GtkFixed * Gtk__Fixed;
#define CastGtk__Fixed GTK_FIXED
typedef GtkFrame * Gtk__Frame;
#define CastGtk__Frame GTK_FRAME
typedef GtkGammaCurve * Gtk__GammaCurve;
#define CastGtk__GammaCurve GTK_GAMMA_CURVE
typedef GtkHBox * Gtk__HBox;
#define CastGtk__HBox GTK_HBOX
typedef GtkHButtonBox * Gtk__HButtonBox;
#define CastGtk__HButtonBox GTK_HBUTTON_BOX
typedef GtkHPaned * Gtk__HPaned;
#define CastGtk__HPaned GTK_HPANED
typedef GtkHRuler * Gtk__HRuler;
#define CastGtk__HRuler GTK_HRULER
typedef GtkHScale * Gtk__HScale;
#define CastGtk__HScale GTK_HSCALE
typedef GtkHScrollbar * Gtk__HScrollbar;
#define CastGtk__HScrollbar GTK_HSCROLLBAR
typedef GtkHSeparator * Gtk__HSeparator;
#define CastGtk__HSeparator GTK_HSEPARATOR
typedef GtkImage * Gtk__Image;
#define CastGtk__Image GTK_IMAGE
typedef GtkInputDialog * Gtk__InputDialog;
#define CastGtk__InputDialog GTK_INPUT_DIALOG
typedef GtkItem * Gtk__Item;
#define CastGtk__Item GTK_ITEM
typedef GtkLabel * Gtk__Label;
#define CastGtk__Label GTK_LABEL
typedef GtkList * Gtk__List;
#define CastGtk__List GTK_LIST
typedef GtkListItem * Gtk__ListItem;
#define CastGtk__ListItem GTK_LIST_ITEM
typedef GtkMenu * Gtk__Menu;
#define CastGtk__Menu GTK_MENU
typedef GtkMenuBar * Gtk__MenuBar;
#define CastGtk__MenuBar GTK_MENU_BAR
typedef GtkMenuItem * Gtk__MenuItem;
#define CastGtk__MenuItem GTK_MENU_ITEM
typedef GtkMenuShell * Gtk__MenuShell;
#define CastGtk__MenuShell GTK_MENU_SHELL
typedef GtkMisc * Gtk__Misc;
#define CastGtk__Misc GTK_MISC
typedef GtkNotebook * Gtk__Notebook;
#define CastGtk__Notebook GTK_NOTEBOOK
typedef GtkObject * Gtk__Object;
#define CastGtk__Object GTK_OBJECT
typedef GtkOptionMenu * Gtk__OptionMenu;
#define CastGtk__OptionMenu GTK_OPTION_MENU
typedef GtkPaned * Gtk__Paned;
#define CastGtk__Paned GTK_PANED
typedef GtkPixmap * Gtk__Pixmap;
#define CastGtk__Pixmap GTK_PIXMAP
typedef GtkPreview * Gtk__Preview;
#define CastGtk__Preview GTK_PREVIEW
typedef GtkProgressBar * Gtk__ProgressBar;
#define CastGtk__ProgressBar GTK_PROGRESS_BAR
typedef GtkRadioButton * Gtk__RadioButton;
#define CastGtk__RadioButton GTK_RADIO_BUTTON
typedef GtkRadioMenuItem * Gtk__RadioMenuItem;
#define CastGtk__RadioMenuItem GTK_RADIO_MENU_ITEM
typedef GtkRange * Gtk__Range;
#define CastGtk__Range GTK_RANGE
typedef GtkRuler * Gtk__Ruler;
#define CastGtk__Ruler GTK_RULER
typedef GtkScale * Gtk__Scale;
#define CastGtk__Scale GTK_SCALE
typedef GtkScrollbar * Gtk__Scrollbar;
#define CastGtk__Scrollbar GTK_SCROLLBAR
typedef GtkScrolledWindow * Gtk__ScrolledWindow;
#define CastGtk__ScrolledWindow GTK_SCROLLED_WINDOW
typedef GtkSeparator * Gtk__Separator;
#define CastGtk__Separator GTK_SEPARATOR
typedef GtkTable * Gtk__Table;
#define CastGtk__Table GTK_TABLE
typedef GtkText * Gtk__Text;
#define CastGtk__Text GTK_TEXT
typedef GtkToggleButton * Gtk__ToggleButton;
#define CastGtk__ToggleButton GTK_TOGGLE_BUTTON
typedef GtkTree * Gtk__Tree;
#define CastGtk__Tree GTK_TREE
typedef GtkTreeItem * Gtk__TreeItem;
#define CastGtk__TreeItem GTK_TREE_ITEM
typedef GtkVBox * Gtk__VBox;
#define CastGtk__VBox GTK_VBOX
typedef GtkVButtonBox * Gtk__VButtonBox;
#define CastGtk__VButtonBox GTK_VBUTTON_BOX
typedef GtkVPaned * Gtk__VPaned;
#define CastGtk__VPaned GTK_VPANED
typedef GtkVRuler * Gtk__VRuler;
#define CastGtk__VRuler GTK_VRULER
typedef GtkVScale * Gtk__VScale;
#define CastGtk__VScale GTK_VSCALE
typedef GtkVScrollbar * Gtk__VScrollbar;
#define CastGtk__VScrollbar GTK_VSCROLLBAR
typedef GtkVSeparator * Gtk__VSeparator;
#define CastGtk__VSeparator GTK_VSEPARATOR
typedef GtkViewport * Gtk__Viewport;
#define CastGtk__Viewport GTK_VIEWPORT
typedef GtkWidget * Gtk__Widget;
#define CastGtk__Widget GTK_WIDGET
typedef GtkWindow * Gtk__Window;
#define CastGtk__Window GTK_WINDOW
