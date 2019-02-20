






/*typedef ReactTableData = EitherType<Array<Dynamic>,Dynamic>;
typedef ReactTableProps =
{
  // General
  data: ReactTableData,
  resolveData: Array<Dynamic>->ReactTableData,
  loading:Bool,
  showPagination:Bool,
  showPaginationTop:Bool,
  showPaginationBottom:Bool
  showPageSizeOptions:Bool,
  pageSizeOptions: Array<Int>,//[5, 10, 20, 25, 50, 100],
  defaultPageSize: Int,//20,
  minRows: Int,//undefined, // controls the minimum number of rows to display - default will be `pageSize`
  // NOTE: if you set minRows to 0 then you get rid of empty padding rows BUT your table formatting will also look strange when there are ZERO rows in the table
  showPageJump:Bool,
  collapseOnSortingChange:Bool,
  collapseOnPageChange:Bool,
  collapseOnDataChange:Bool,
  freezeWhenExpanded:Bool,
  sortable:Bool,
  multiSort:Bool,
  resizable:Bool,
  filterable:Bool,
  defaultSortDesc:Bool,
  defaultSorted: Array<Dynamic>,
  defaultFiltered: Array<Dynamic>,
  defaultResized: Array<Dynamic>,
  defaultExpanded: {},
  defaultFilterMethod: (filter, row, column) => {
    const id = filter.pivotId || filter.id
    return row[id] !== undefined ? String(row[id]).startsWith(filter.value) :Bool
  },
  defaultSortMethod: (a, b, desc) => {
    // force null and undefined to the bottom
    a = a === null || a === undefined ? '' : a
    b = b === null || b === undefined ? '' : b
    // force any string values to lowercase
    a = typeof a === 'string' ? a.toLowerCase() : a
    b = typeof b === 'string' ? b.toLowerCase() : b
    // Return either 1 or -1 to indicate a sort priority
    if (a > b) {
      return 1
    }
    if (a < b) {
      return -1
    }
    // returning 0, undefined or any falsey value will use subsequent sorts or
    // the index as a tiebreaker
    return 0
  },
  PadRowComponent: () => <span>&nbsp;</span>, // the content rendered inside of a padding row

  // Controlled State Overrides (see Fully Controlled Component section)
  page: undefined,
  pageSize: undefined,
  sorted: Array<Dynamic>,
  filtered: Array<Dynamic>,
  resized: Array<Dynamic>,
  expanded: Dynamic,

  // Controlled State Callbacks
  onPageChange: Function,
  onPageSizeChange: Function,
  onSortedChange: Function,
  onFilteredChange: Function,
  onResizedChange: Function,
  onExpandedChange: Function,

  // Pivoting
  pivotBy: undefined,

  // Key Constants
  pivotValKey: '_pivotVal',
  pivotIDKey: '_pivotID',
  subRowsKey: '_subRows',
  aggregatedKey: '_aggregated',
  nestingLevelKey: '_nestingLevel',
  originalKey: '_original',
  indexKey: '_index',
  groupedByPivotKey: '_groupedByPivot',

  // Server-side callbacks
  onFetchData: () => null,

  // Classes
  className: '',
  style: {},

  // Component decorators
  getProps: Void->Dynamic,
  getTableProps: Void->Dynamic,
  getTheadGroupProps: Void->Dynamic,
  getTheadGroupTrProps: Void->Dynamic,
  getTheadGroupThProps: Void->Dynamic,
  getTheadProps: Void->Dynamic,
  getTheadTrProps: Void->Dynamic,
  getTheadThProps: Void->Dynamic,
  getTheadFilterProps: Void->Dynamic,
  getTheadFilterTrProps: Void->Dynamic,
  getTheadFilterThProps: Void->Dynamic,
  getTbodyProps: Void->Dynamic,
  getTrGroupProps: Void->Dynamic,
  getTrProps: Void->Dynamic,
  getThProps: Void->Dynamic,
  getTdProps: Void->Dynamic,
  getTfootProps: Void->Dynamic,
  getTfootTrProps: Void->Dynamic,
  getTfootThProps: Void->Dynamic,
  getPaginationProps: Void->Dynamic,
  getLoadingProps: Void->Dynamic,
  getNoDataProps: Void->Dynamic,
  getResizerProps: Void->Dynamic,

  // Global Column Defaults
  // To override only some values, import { ReactTableDefaults } from 'react-table'
  // and construct your overrides (e.g. {...ReactTableDefaults.column, className: 'react-table-cell'})
  column: {
    // Renderers
    Cell: undefined,
    Header: undefined,
    Footer: undefined,
    Aggregated: undefined,
    Pivot: undefined,
    PivotValue: undefined,
    Expander: undefined,
    Filter: undefined,
    // Standard options
    sortable: undefined, // use table default
    resizable: undefined, // use table default
    filterable: undefined, // use table default
    show:Bool,
    minWidth: 100,
    // Cells only
    className: '',
    style: {},
    getProps: Void->Dynamic,
    // Headers only
    headerClassName: '',
    headerStyle: {},
    getHeaderProps: Void->Dynamic
    // Footers only
    footerClassName: '',
    footerStyle: {},
    getFooterProps: Void->Dynamic,
    filterAll:Bool,
    filterMethod: undefined,
    sortMethod: undefined,
    defaultSortDesc: undefined,
  },

  // Global Expander Column Defaults
  // To override only some values, import { ReactTableDefaults } from 'react-table'
  // and construct your overrides (e.g. {...ReactTableDefaults.expanderDefaults, sortable:Bool})
  expanderDefaults: {
    sortable:Bool,
    resizable:Bool,
    filterable:Bool,
    width: 35
  },

  // Global Pivot Column Defaults
  pivotDefaults: {},

  // Text
  previousText: 'Previous',
  nextText: 'Next',
  loadingText: 'Loading...',
  noDataText: 'No rows found',
  pageText: 'Page',
  ofText: 'of',
  rowsText: 'rows',
  
  // Accessibility Labels
  pageJumpText: 'jump to page',
  rowsSelectorText: 'rows per page',
}

typedef ReactTableState = 
{
    page: Int,
    pageSize: Int,
    sorted: props.defaultSorted,
    expanded: Dynamic,
    filtered: props.defaultFiltered,
    resized: props.defaultResized,
    currentlyResizing: false,
    skipNextSort: false
};
*/